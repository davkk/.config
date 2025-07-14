local marks_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "marks")
if not vim.fn.isdirectory(marks_dir) then vim.fn.mkdir(marks_dir, "p") end

local cwd = vim.fn.getcwd()
local marks_file = vim.fs.joinpath(marks_dir, vim.fn.sha256(cwd))
local marks = {}

local ok, content = pcall(vim.fn.readfile, marks_file)
if ok then
    marks = content or {}
end

local menu_win, menu_buf

local function save_marks()
    pcall(vim.fn.writefile, marks, marks_file)
end

local function add_mark()
    if vim.bo.buftype ~= "" or vim.fn.expand("%") == "" then return end
    local path = vim.fn.expand("%:p"):sub(#cwd + 2)
    for i, mark in ipairs(marks) do
        if mark == path or #mark == 0 then
            table.remove(marks, i)
        end
    end
    table.insert(marks, path)
    save_marks()
end

---@param n number
local function nav_file(n)
    if vim.bo.buftype ~= "" then return end
    local mark = marks[n]
    if mark and #mark > 0 and vim.fn.filereadable(mark) == 1 then
        vim.cmd.edit(vim.fn.fnameescape(mark))
    end
end

local function close_menu()
    marks = vim.api.nvim_buf_get_lines(menu_buf, 0, -1, false)
    save_marks()
    vim.api.nvim_win_close(menu_win, true)
    menu_win, menu_buf = nil, nil
end

local function open_menu()
    local current_file = vim.fn.expand("%:p"):sub(#cwd + 2)

    menu_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(menu_buf, 0, -1, false, marks)
    vim.api.nvim_buf_set_name(menu_buf, "marks")
    vim.bo[menu_buf].buftype = "acwrite"
    vim.bo[menu_buf].bufhidden = "wipe"

    menu_win = vim.api.nvim_open_win(menu_buf, true, {
        relative = "editor",
        width = vim.o.columns,
        height = math.floor(vim.o.lines * 0.4),
        row = vim.o.lines,
        col = 1,
        border = "solid",
    })
    vim.wo[menu_win].signcolumn = "auto"
    vim.wo[menu_win].fillchars = "eob: "
    vim.wo[menu_win].relativenumber = false

    for i, mark in ipairs(marks) do
        if mark == current_file then
            vim.api.nvim_win_set_cursor(menu_win, { i, 0 })
            break
        end
    end

    vim.api.nvim_create_autocmd({ "BufWriteCmd", "BufLeave" }, {
        group = vim.api.nvim_create_augroup("user.marks", { clear = true }),
        buffer = menu_buf,
        callback = close_menu,
    })

    local opts = { buffer = menu_buf, noremap = true, silent = true }
    vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_win_get_cursor(menu_win)[1]
        vim.api.nvim_win_close(menu_win, true)
        nav_file(line)
    end, opts)
    vim.keymap.set("n", "<esc>", close_menu, opts)
    vim.keymap.set("n", "<C-c>", close_menu, opts)
end

vim.keymap.set("n", "<leader>a", add_mark, { silent = true })
vim.keymap.set("n", "<leader>h", function()
    if menu_win then close_menu() else open_menu() end
end, { silent = true })

for idx = 1, 5 do
    vim.keymap.set("n", tostring(idx), function() nav_file(idx) end, { silent = true })
end
