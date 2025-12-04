local M = {}

local utils = require "core.utils"
local async = require "core.async"

---@class ai.LocalContext
---@field prefix string
---@field middle string
---@field suffix string

---@class ai.LspContext
---@field logit_bias table<string, string>
---@field completions string?
---@field signatures string?

local ns = vim.api.nvim_create_namespace "user.ai"
local group = vim.api.nvim_create_augroup("ai", { clear = true })

M.handle = nil
M.stdout = nil
M.extmark_id = nil

M.suggestion = ""

M.request_id = 0
M.current_request_id = 0

---@type table<string, string>
M.cache = {}
---@type table<string>
M.lru = {}

local N_PREFIX = 32
local N_SUFFIX = 16

local MAX_CACHE = 256
local MAX_TOKENS = 16

local URL = "http://localhost:8012"
local STOP_CHARS = { "\n", "\r", "\r\n" }

---@param context ai.LocalContext
local function get_hash(context)
    return vim.fn.sha256(context.prefix .. context.middle .. "█" .. context.suffix)
end

---@param context ai.LocalContext
---@param value string
function M.cache_add(context, value)
    if vim.tbl_count(M.cache) > MAX_CACHE - 1 then
        local least_used = M.lru[1]
        M.cache[least_used] = nil
        table.remove(M.lru, 1)
    end

    local hash = get_hash(context)
    M.cache[hash] = value

    M.lru = vim.tbl_filter(function(k)
        return k ~= hash
    end, M.lru)
    M.lru[#M.lru + 1] = hash
end

---@param context ai.LocalContext
function M.cache_get(context)
    local hash = get_hash(context)
    local value = M.cache[hash]
    if not value then
        return nil
    end

    M.lru = vim.tbl_filter(function(k)
        return k ~= hash
    end, M.lru)
    M.lru[#M.lru + 1] = hash

    return value
end

---@param local_context ai.LocalContext
---@param lsp_context ai.LspContext
function M.request_infill(local_context, lsp_context)
    if vim.bo.readonly or vim.bo.buftype ~= "" then
        return
    end

    M.cancel()
    M.clear()
    M.suggestion = ""

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local request_id = M.current_request_id

    local input_extra = {}
    if lsp_context.completions then
        input_extra[#input_extra + 1] = {
            filename = "in_scope_symbols",
            text = lsp_context.completions,
        }
    end
    if lsp_context.signatures then
        input_extra[#input_extra + 1] = {
            filename = "active_call_hint",
            text = lsp_context.signatures,
        }
    end

    local stop = utils.tbl_copy(STOP_CHARS)
    local clients = vim.lsp.get_clients { bufnr = 0 }
    for _, client in ipairs(clients) do
        for _, char in ipairs(client.server_capabilities.completionProvider.triggerCharacters or {}) do
            if char ~= " " and not vim.tbl_contains(stop, char) then
                stop[#stop + 1] = char
            end
        end
    end

    local payload = vim.json.encode {
        input_prefix = local_context.prefix,
        prompt = local_context.middle,
        input_suffix = local_context.suffix,
        input_extra = input_extra,
        cache_prompt = true,
        max_tokens = MAX_TOKENS,
        top_k = 40,
        top_p = 0.5,
        repeat_penalty = 1.3,
        samplers = { "top_k", "top_p", "infill" },
        logit_bias = lsp_context.logit_bias,
        t_max_predict_ms = 500,
        stream = true,
        stop = stop,
    }

    M.stdout = vim.uv.new_pipe(false)
    M.handle = vim.uv.spawn("curl", {
        args = {
            ("%s/infill"):format(URL),
            "--no-buffer",
            "--request",
            "POST",
            "-H",
            "Content-Type: application/json",
            "-d",
            payload,
        },
        stdio = { nil, M.stdout },
    }, function(code)
        if M.stdout then
            M.stdout:close()
            M.stdout = nil
        end
        if M.handle then
            M.handle:close()
            M.handle = nil
        end
        if code ~= 0 then
            vim.schedule(function()
                vim.notify(("curl exited with code %d"):format(code), vim.diagnostic.severity.ERROR)
            end)
        end
    end)
    if not M.handle then
        vim.notify("Failed to spawn curl process", vim.diagnostic.severity.ERROR)
        return
    end
    M.stdout:read_start(function(_, chunk)
        if chunk then
            M.on_chunk(chunk, local_context, request_id, row, col)
        end
    end)
end

---@param text string
---@param row number
---@param col number
function M.show_suggestion(text, row, col)
    M.extmark_id = vim.api.nvim_buf_set_extmark(0, ns, row - 1, col, {
        id = M.extmark_id,
        virt_text = { { text, "Comment" } },
        virt_text_pos = "overlay",
    })
end

---@param chunk string
---@param context ai.LocalContext
---@param request_id number
---@param row number
---@param col number
function M.on_chunk(chunk, context, request_id, row, col)
    if request_id ~= M.current_request_id then
        return
    end
    if #chunk > 6 and chunk:sub(1, 6) == "data: " then
        chunk = chunk:sub(7)
        local ok, resp = pcall(vim.json.decode, chunk)
        if ok then
            local text = resp.content
            if resp.stop then
                if resp.stop_type == "word" and not vim.tbl_contains(STOP_CHARS, resp.stopping_word) then
                    text = resp.stopping_word
                else
                    return
                end
            end
            M.suggestion = M.suggestion .. text
            vim.schedule(function()
                M.show_suggestion(M.suggestion, row, col)
                if request_id == M.current_request_id and M.suggestion and #M.suggestion > 0 then
                    M.cache_add(context, M.suggestion)
                end
            end)
        end
    end
end

function M.clear()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    M.extmark_id = nil
end

function M.cancel()
    pcall(function()
        if M.stdout then
            M.stdout:close()
            M.stdout = nil
        end
        if M.handle then
            M.handle:close()
            M.handle = nil
        end
    end)
end

---@return ai.LocalContext
local function get_local_context()
    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local prefix = table.concat(lines, "\n", math.max(0, row - 1 - N_PREFIX) + 1, math.max(0, row - 1)) .. "\n"
    local curr_prefix = lines[row]:sub(1, col)

    local curr_suffix = lines[row]:sub(col + 1)
    local suffix = (#curr_suffix > 0 and curr_suffix .. "\n" or "")
        .. "\n"
        .. table.concat(lines, "\n", math.min(#lines + 1, row + 1), math.min(#lines, row + N_SUFFIX + 1))
        .. "\n"

    return { prefix = prefix, middle = curr_prefix, suffix = suffix }
end

---@param a string
---@param b string
---@return string, string, string
local function overlap(a, b)
    local max_overlap = math.min(#a, #b)
    local ol = 0
    for i = 1, max_overlap do
        local a_end = a:sub(-i)
        local b_start = b:sub(1, i)
        if a_end == b_start then
            ol = i
        end
    end
    return a:sub(1, #a - ol), a:sub(#a - ol + 1), b:sub(ol + 1)
end

---@param route string
---@param payload string
local function request_json(route, payload)
    return function(resume)
        local stdout_chunks = {}
        local stderr_chunks = {}
        vim.fn.jobstart({
            "curl",
            ("%s/%s"):format(URL, route),
            "--request",
            "POST",
            "-H",
            "Content-Type: application/json",
            "-d",
            payload,
        }, {
            on_stdout = function(_, data)
                if data then
                    stdout_chunks[#stdout_chunks + 1] = table.concat(data, "\n")
                end
            end,
            on_stderr = function(_, data)
                if data then
                    stderr_chunks[#stderr_chunks + 1] = table.concat(data, "\n")
                end
            end,
            on_exit = function(_, code)
                if code == 0 then
                    resume(nil, vim.json.decode(table.concat(stdout_chunks)))
                else
                    resume(table.concat(stderr_chunks))
                end
            end,
        })
    end
end

---@param method string
---@param buf number
---@param params table
local function lsp_request(buf, method, params)
    return function(resume)
        pcall(vim.lsp.buf_request_all, buf, method, params, function(results)
            resume(results)
        end)
    end
end

local function is_function(kind)
    return kind == vim.lsp.protocol.CompletionItemKind.Function or kind == vim.lsp.protocol.CompletionItemKind.Method
end

---@param line string
---@return ai.LspContext
local function get_lsp_context(line)
    local params = vim.lsp.util.make_position_params(0, "utf-8")

    ---@type table<integer, { err: (lsp.ResponseError)?, result: any, context: lsp.HandlerContext }>
    local sig_resp = async.await(lsp_request(0, "textDocument/signatureHelp", params)) or {}
    local signatures = {}
    for _, resp in ipairs(sig_resp) do
        if resp.err then
            break
        end
        if resp.result and resp.result.signatures then
            for _, sig in ipairs(resp.result.signatures) do
                local signature = {}
                if sig.documentation and sig.documentation.value then
                    signature[#signature + 1] = vim.api
                        .nvim_get_option_value("commentstring", { buf = 0 })
                        :format(sig.documentation.value:gsub("\n", " "))
                end
                if sig.label then
                    signature[#signature + 1] = sig.label
                end
                signatures[#signatures + 1] = table.concat(signature, "\n")
            end
        end
    end

    ---@type table<integer, { err: (lsp.ResponseError)?, result: any, context: lsp.HandlerContext }>
    local cmp_resp = async.await(lsp_request(0, "textDocument/completion", params)) or {}
    local items = {}
    for _, resp in ipairs(cmp_resp) do
        if resp.err then
            break
        end
        if resp.result and resp.result.items then
            for _, item in ipairs(resp.result.items) do
                items[#items + 1] = item
            end
        end
    end

    local re = vim.regex [[\k*$]]
    local s, e = re:match_str(line)
    local keyword = s and line:sub(s + 1, e) or ""

    local completions = {}
    local tokenize_promises = {}

    local num_items = 0
    for _, v in ipairs(items) do
        if num_items > 20 then
            break
        end
        if v.kind ~= 15 and v.label and v.label:sub(1, #keyword) == keyword then
            local label = ("%s %s"):format(vim.lsp.protocol.CompletionItemKind[v.kind]:lower(), v.label)
            if is_function(v.kind) and not label:match "%(" then
                label = label .. "("
            end
            if v.detail then
                label = ("%s -> %s"):format(label, v.detail)
            end
            completions[#completions + 1] = label

            local content = (v.filterText or v.insertText or v.label):gsub("^%.", ""):sub(#keyword + 1)
            if is_function(v.kind) and not content:match "%(" then
                content = content .. "("
            end
            tokenize_promises[#tokenize_promises + 1] = request_json(
                "tokenize",
                vim.json.encode {
                    content = content,
                    with_pieces = true,
                }
            )

            num_items = num_items + 1
        end
    end

    local err_all, all_tokens = async.all(tokenize_promises)
    if err_all ~= nil then
        return {}
    end

    local logit_bias = {}
    for _, tokens in ipairs(all_tokens or {}) do
        for _, token in ipairs(tokens.tokens) do
            local piece = token.piece
            if not logit_bias[piece] then
                logit_bias[piece] = 2
            end
        end
    end

    return {
        logit_bias = logit_bias,
        completions = #completions > 0 and table.concat(completions, "\n") .. "\n" or nil,
        signatures = #signatures > 0 and table.concat(signatures, "\n") .. "\n" or nil,
    }
end

function M.accept()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    local suffix = line:sub(col + 1)

    local new_text = overlap(M.suggestion, suffix)
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { new_text })
    vim.api.nvim_win_set_cursor(0, { row, col + #M.suggestion })

    M.clear()
    M.suggestion = ""
end

---@param local_context ai.LocalContext
function M.suggest(local_context)
    M.cancel()
    M.clear()
    M.suggestion = ""

    M.request_id = M.request_id + 1
    local this_generation = M.request_id

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local best = ""
    local cached = M.cache_get(local_context)

    for i = 1, 64 do
        if cached then
            best = cached
            break
        end

        local new_middle = local_context.middle:sub(1, #local_context.middle - i)
        if #new_middle == 0 then
            break
        end

        local new_context = {
            prefix = local_context.prefix,
            middle = new_middle,
            suffix = local_context.suffix,
        }
        local hit = M.cache_get(new_context)
        if hit then
            local removed = local_context.middle:sub(#local_context.middle - i + 1)
            if hit:sub(1, #removed) == removed then
                local remain = hit:sub(#removed + 1)
                if #remain > #best then
                    best = remain
                end
            end
        end
    end

    if #best > 0 then
        M.current_request_id = this_generation
        M.suggestion = best
        M.show_suggestion(best, row, col)
        return
    end

    async.async(function()
        local lsp_context = get_lsp_context(local_context.middle)

        if M.request_id ~= this_generation then
            return
        end

        M.current_request_id = this_generation
        vim.schedule(function()
            M.request_infill(local_context, lsp_context)
        end)
    end)()
end

vim.api.nvim_create_user_command("AI", function()
    vim.keymap.set("i", "<C-q>", function()
        if #M.suggestion > 0 then
            if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
            end
            vim.defer_fn(M.accept, 10)
        end
    end)

    vim.keymap.set("i", "<C-space>", function()
        async.async(function()
            local local_context = get_local_context()
            local lsp_context = get_lsp_context(local_context.middle)
            vim.schedule(function()
                M.request_infill(local_context, lsp_context)
            end)
        end)()
    end)

    vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP", "InsertEnter" }, {
        group = group,
        callback = function()
            M.suggest(get_local_context())
        end,
    })

    vim.api.nvim_create_autocmd({ "InsertLeavePre", "CursorMoved", "CursorMovedI" }, {
        group = group,
        callback = function()
            M.clear()
            M.cancel()
        end,
    })
end, {})

return M
