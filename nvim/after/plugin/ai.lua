local M = {}

---@class ai.LocalContext
---@field prefix string
---@field middle string
---@field suffix string

local ns = vim.api.nvim_create_namespace "user.ai"

M.handle = nil
M.stdout = nil
M.extmark_id = nil

M.timer = nil
M.suggestion = ""

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
function M.request(context)
    if vim.bo.readonly or vim.bo.buftype ~= "" then
        return
    end

    M.cancel()

    M.suggestion = ""
    M.stdout = vim.uv.new_pipe(false)

    local payload = vim.json.encode {
        input_prefix = context.prefix,
        prompt = context.middle,
        input_suffix = context.suffix,
        cache_prompt = true,
        samplers = { "top_k", "top_p", "infill" },
        max_tokens = 16,
        top_p = 0.8,
        top_k = 40,
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

        vim.schedule(function()
            if M.suggestion and #M.suggestion > 0 then
                M.cache_add(context, M.suggestion)
            end
        end)
    end)

    if not M.handle then
        vim.notify("Failed to spawn curl process", vim.diagnostic.severity.ERROR)
        return
    end

    M.stdout:read_start(function(_, chunk)
        if chunk then
            M.on_chunk(chunk)
        end
    end)
end

---@param text string
function M.show_suggestion(text)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    M.extmark_id = vim.api.nvim_buf_set_extmark(0, ns, row - 1, col, {
        id = M.extmark_id,
        virt_text = { { text, "Comment" } },
        virt_text_pos = "overlay",
    })
end

---@param chunk string
function M.on_chunk(chunk)
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
                M.show_suggestion(M.suggestion)
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
        M.stdout = nil
        M.handle = nil
    end
    M.clear()
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
        .. table.concat(lines, "\n", math.min(#lines + 1, row + 1), math.min(#lines, row + N_SUFFIX + 1))
        .. "\n"

    return { prefix = prefix, middle = curr_prefix .. vim.v.char, suffix = suffix }
end

function M.accept()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    local suffix = line:sub(col + 1)

    local max_overlap = math.min(#suffix, #M.suggestion)
    local overlap = 0

    for i = 1, max_overlap do
        local buffer_end = M.suggestion:sub(-i)
        local suffix_start = suffix:sub(1, i)

        if buffer_end == suffix_start then
            overlap = i
        end
    end

    local new_text = M.suggestion:sub(1, -overlap - 1)
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { new_text })
    vim.api.nvim_win_set_cursor(0, { row, col + #M.suggestion })

    M.suggestion = ""
    M.clear()
end

---@param context ai.LocalContext
function M.suggest(context)
    local best = nil
    local best_len = 0

    local cached = M.cache_get(context)
    for i = 1, 64 do
        if cached then
            best = cached
            break
        end

        local new_middle = context.middle:sub(1, #context.middle - i)
        if #new_middle == 0 then
            break
        end

        local new_context = {
            prefix = context.prefix,
            middle = new_middle,
            suffix = context.suffix,
        }
        local hit = M.cache_get(new_context)
        if hit then
            local removed = context.middle:sub(#context.middle - i + 1)
            if hit:sub(1, #removed) == removed then
                local remain = hit:sub(#removed + 1)
                if #remain > best_len then
                    best = remain
                    best_len = #remain
                end
            end
        end
    end

    if best then
        M.suggestion = best
        return M.show_suggestion(best)
    end
    return M.request(context)
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
        M.suggest(get_local_context())
    end)

    vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP", "InsertEnter", "CursorMovedI" }, {
        callback = function()
            M.suggest(get_local_context())
        end,
    })

    vim.api.nvim_create_autocmd("InsertLeavePre", { callback = M.cancel })
    vim.api.nvim_create_autocmd("CursorMoved", { callback = M.cancel })
end, {})

return M
