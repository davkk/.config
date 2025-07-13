local enabled = true

local config = {
    "function_declaration",
    "function_definition",
    "method_declaration",
    "method_definition",
    "class_declaration",
    "class_definition",
    "class_specifier",
    "struct_specifier",
    "interface_declaration",
    "expression_statement",
}

local buf_id = nil
local win_id = nil

local function cleanup()
    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
    end

    if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
        vim.api.nvim_buf_delete(buf_id, { force = true })
        buf_id = nil
    end
end

local function find_context_node()
    local node = vim.treesitter.get_node()
    if not node then return nil end

    local top_visible_line = vim.fn.line("w0")

    while node do
        local context_start_line = node:start() + 1

        if context_start_line < top_visible_line then
            if vim.tbl_contains(config, node:type()) then
                return node
            end
        end

        node = node:parent()
    end

    return nil
end

---@param node TSNode
---@return string | nil
local function get_context_text(node)
    local bufnr = vim.api.nvim_get_current_buf()
    local start_row = node:start()
    return vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
end

local function get_context_buffer()
    if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
        buf_id = vim.api.nvim_create_buf(false, true)
        vim.bo[buf_id].buftype = "nofile"
        vim.bo[buf_id].bufhidden = "wipe"
        vim.bo[buf_id].filetype = vim.bo.filetype
    end

    return buf_id
end

local function display_context()
    local context_node = find_context_node()

    if not context_node then
        cleanup()
        return
    end

    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local context_start_line = context_node:start() + 1

    local relative_line = cursor_line - context_start_line
    local context_text = get_context_text(context_node)

    local last_line = vim.fn.line("$")
    local line_width = tostring(last_line):len()
    if vim.api.nvim_get_option_value("diff", { win = 0 }) then
        line_width = 5
    elseif line_width <= 2 then
        line_width = 3
    end
    line_width = line_width + 2

    local line_number_text = string.format("%" .. line_width .. "d", relative_line)
    context_text = line_number_text .. " " .. context_text

    local context_buf = get_context_buffer()
    vim.api.nvim_buf_set_lines(context_buf, 0, -1, false, { context_text })

    vim.hl.range(
        context_buf,
        vim.api.nvim_create_namespace("TreesitterContextNamespace"),
        "TreesitterContextLineNr",
        { 0, 0 },
        { 0, #line_number_text }
    )

    local cur_win = vim.api.nvim_get_current_win()
    local win_width = vim.api.nvim_win_get_width(cur_win)

    local win_config = {
        relative = "win",
        win = cur_win,
        row = 0,
        col = 0,
        width = win_width,
        height = 1,
        style = "minimal",
        zindex = 20,
        border = "none",
    }

    if not win_id or not vim.api.nvim_win_is_valid(win_id) then
        win_id = vim.api.nvim_open_win(context_buf, false, win_config)
        vim.wo[win_id].wrap = false
        vim.wo[win_id].winhighlight = "Normal:TreesitterContext"
    else
        vim.api.nvim_win_set_config(win_id, win_config)
    end
end

local group = vim.api.nvim_create_augroup("user.context", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    callback = function()
        if not enabled then return end

        local mode = vim.fn.mode()
        if mode:match("[vV\22]") then
            cleanup()
            return
        end

        vim.schedule(display_context)
    end
})

vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = cleanup
})

vim.api.nvim_create_user_command("TreesitterContextToggle", function()
    if win_id and vim.api.nvim_win_is_valid(win_id) then
        cleanup()
        enabled = false
    else
        display_context()
        enabled = true
    end
end, { desc = "Toggle TreeSitter context display" })
