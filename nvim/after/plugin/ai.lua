local M = {}

---@class ai.LocalContext
---@field prefix string
---@field middle string
---@field suffix string

local ns = vim.api.nvim_create_namespace "user.ai"

local handle
local stdout
local current_buf

local extmark_id
local buffer

local N_PREFIX = 32
local N_SUFFIX = 16

function M.request()
    if vim.bo.readonly or vim.bo.buftype ~= "" then
        return
    end
    M.cancel()

    buffer = ""
    current_buf = vim.api.nvim_get_current_buf()
    stdout = vim.uv.new_pipe(false)

    local context = M.get_local_context()
    local payload = vim.json.encode {
        input_prefix = context.prefix,
        prompt = context.middle,
        input_suffix = context.suffix,
        cache_prompt = true,
        samplers = { "top_k", "top_p", "infill" },
        max_tokens = 16,
        top_p = 0.9,
        top_k = 40,
        temperature = 0.5,
        stream = true,
        stop = { "\r\n", "\n", "\r" },
    }

    handle = vim.uv.spawn("curl", {
        args = {
            "http://localhost:42069/infill",
            "--no-buffer",
            "--request",
            "POST",
            "-H",
            "Content-Type: application/json",
            "-d",
            payload,
        },
        stdio = { nil, stdout },
    }, function(code)
        if stdout then
            stdout:close()
        end
        if handle then
            handle:close()
        end
        stdout = nil
        handle = nil
        vim.schedule(function()
            if code ~= 0 then
                vim.notify(("curl exited with code %d"):format(code), vim.diagnostic.severity.ERROR)
            end
        end)
    end)

    if not handle then
        vim.notify("Failed to spawn curl process", vim.diagnostic.severity.ERROR)
        return
    end

    if stdout then
        stdout:read_start(function(_, chunk)
            if chunk and #chunk > 6 and chunk:sub(1, 6) == "data: " then
                chunk = chunk:sub(7)
                local ok, resp = pcall(vim.json.decode, chunk)
                if ok then
                    local text = resp.content
                    if text == "" or text == nil then
                        return
                    else
                        M.on_chunk(text)
                    end
                end
            end
        end)
    end
end

local timer = nil
function M.debounced_request()
    if timer then
        timer:stop()
    end
    timer = vim.uv.new_timer()
    if timer then
        timer:start(
            10,
            0,
            vim.schedule_wrap(function()
                M.request()
                timer = nil
            end)
        )
    end
end

---@param text string
local function show_completion(text)
    if not current_buf then
        return
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    extmark_id = vim.api.nvim_buf_set_extmark(current_buf, ns, row - 1, col, {
        id = extmark_id,
        virt_text = { { text, "Comment" } },
        virt_text_pos = "overlay",
    })
end

---@param chunk string
function M.on_chunk(chunk)
    buffer = buffer .. chunk
    vim.schedule(function()
        M.clear()
        show_completion(buffer)
    end)
end

function M.clear()
    if extmark_id and current_buf then
        vim.api.nvim_buf_del_extmark(current_buf, ns, extmark_id)
        extmark_id = nil
    end
end

function M.cancel()
    if handle then
        handle:kill()
        if stdout then
            stdout:close()
        end
        handle:close()
        stdout = nil
        handle = nil
    end
    M.clear()
    current_buf = nil
end

---@return ai.LocalContext
function M.get_local_context()
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

vim.api.nvim_create_user_command("AI", function()
    vim.keymap.set("i", "<C-q>", function()
        if handle then
            return
        end
        if #buffer > 0 then
            if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
            end
            vim.defer_fn(function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { buffer })
                vim.api.nvim_win_set_cursor(0, { row, col + #buffer })
                buffer = ""
            end, 10)
        end
    end)

    vim.keymap.set("i", "<C-space>", M.request)
    vim.keymap.set("i", "<C-x>", M.cancel)

    vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
        callback = function()
            M.cancel()
            M.debounced_request()
        end,
    })
    vim.api.nvim_create_autocmd("InsertEnter", { callback = M.request })
    vim.api.nvim_create_autocmd("InsertLeavePre", { callback = M.cancel })
    vim.api.nvim_create_autocmd("CursorMoved", { callback = M.cancel })
end, {})

return M
