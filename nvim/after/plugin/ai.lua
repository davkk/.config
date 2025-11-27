local M = {}
local utils = require "core.utils"

---@class ai.LocalContext
---@field prefix string
---@field middle string
---@field suffix string

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
    table.insert(M.lru, hash)
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
    table.insert(M.lru, hash)

    return value
end

---@param context ai.LocalContext
M.request = utils.debounce(function(context, lsp_context)
    if vim.bo.readonly or vim.bo.buftype ~= "" then
        return
    end

    M.clear()
    M.cancel()

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    M.suggestion = ""
    M.request_id = M.request_id + 1

    local request_id = M.request_id
    M.current_request_id = request_id
    M.stdout = vim.uv.new_pipe(false)

    local payload = vim.json.encode {
        input_prefix = context.prefix,
        prompt = context.middle,
        input_suffix = context.suffix,
        input_extra = { lsp_context.input_extra },
        cache_prompt = true,
        max_tokens = 16,
        top_k = 40,
        top_p = 0.7,
        samplers = { "top_k", "top_p", "infill" },
        logit_bias = lsp_context.logit_bias,
        t_max_prompt_ms = 500,
        t_max_predict_ms = 500,
        stream = true,
        stop = { "\r\n", "\n", "\r" },
    }

    M.handle = vim.uv.spawn("curl", {
        args = {
            "http://localhost:8012/infill",
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
            M.on_chunk(chunk, context, request_id, row, col)
        end
    end)
end, 100)

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
            if text == "" or text == nil then
                return
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
    if M.extmark_id then
        vim.api.nvim_buf_del_extmark(0, ns, M.extmark_id)
        M.extmark_id = nil
    end
end

function M.cancel()
    if M.handle then
        M.handle:kill()
        if M.stdout then
            M.stdout:close()
        end
        M.handle:close()
    end
    M.stdout = nil
    M.handle = nil
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
---@return string, string
local function remove_overlap(a, b)
    local max_overlap = math.min(#a, #b)
    local overlap = 0
    for i = 1, max_overlap do
        local a_end = a:sub(-i)
        local b_start = b:sub(1, i)
        if a_end == b_start then
            overlap = i
        end
    end
    return a:sub(1, #a - overlap), b:sub(overlap + 1)
end

---@param trie table<string, table<string>>
---@param word string
local function unique_suffix(trie, word)
    local curr = trie
    local unique
    for i = 1, #word do
        local char = word:sub(i, i)
        if not curr[char] then
            curr[char] = {}
            if not unique then
                unique = i
            end
        end
        curr = curr[char]
    end
    return unique and word:sub(unique) or word
end

---@param line string
local function get_lsp_context(line)
    local co = assert(coroutine.running())

    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    vim.lsp.buf_request(
        buf,
        "textDocument/completion",
        vim.lsp.util.make_position_params(win, "utf-8"),
        function(err, result)
            if err then
                coroutine.resume(co, {})
                return
            end
            local trie = {}
            local completions = {}
            local logit_bias = {}
            if result and result.items then
                for i, v in ipairs(result.items) do
                    if i > 10 then
                        break
                    end
                    if v.kind ~= 15 and v.label then
                        local label = v.label
                        if v.detail then
                            label = label .. " -> " .. v.detail
                        end
                        table.insert(completions, label)

                        if v.filterText or v.insertText then
                            local _, rest = remove_overlap(line, v.filterText or v.insertText or v.label)
                            table.insert(logit_bias, { unique_suffix(trie, rest), 1 })
                        end
                    end
                end
            end
            coroutine.resume(co, {
                logit_bias = logit_bias,
                input_extra = #completions > 0 and {
                    filename = "filename",
                    text = table.concat(completions, "\n") .. "\n",
                } or nil,
            })
        end
    )

    return coroutine.yield()
end

function M.accept()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    local suffix = line:sub(col + 1)

    local new_text = remove_overlap(M.suggestion, suffix)
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { new_text })
    vim.api.nvim_win_set_cursor(0, { row, col + #M.suggestion })

    M.suggestion = ""
    M.clear()
end

---@param local_context ai.LocalContext
function M.suggest(local_context)
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
        M.suggestion = best
        return M.show_suggestion(best, row, col)
    end

    M.clear()

    return coroutine.resume(coroutine.create(function()
        local lsp_context = get_lsp_context(local_context.middle)
        M.request(local_context, lsp_context)
    end))
end

vim.api.nvim_create_user_command("AI", function()
    vim.keymap.set("i", "<C-q>", function()
        if M.handle then
            return
        end
        if #M.suggestion > 0 then
            if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
            end
            vim.defer_fn(M.accept, 10)
        end
    end)

    vim.keymap.set("i", "<C-space>", function()
        coroutine.resume(coroutine.create(function()
            local local_context = get_local_context()
            local lsp_context = get_lsp_context(local_context.middle)
            M.request(local_context, lsp_context)
        end))
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
