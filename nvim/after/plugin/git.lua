local function create_scratch_split(lines, filetype)
    vim.cmd("leftabove vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = filetype or vim.bo.filetype
end

local function replace_with_scratch(lines, filetype)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"; vim.bo[buf].modifiable = false; vim.bo[buf].filetype = filetype or vim.bo.filetype
end

---@param ref string | nil
local function git_diff(ref)
    ref = ref or "HEAD"
    local cwd = vim.fn.getcwd()
    local filepath = vim.fn.expand("%:p")
    local relative_filepath = filepath:sub(#cwd + 2)

    -- If it's a submodule, just show the current hash and stop.
    local ls_files_res = vim.system({ "git", "ls-files", "--stage", "--", relative_filepath }):wait()
    if ls_files_res.code == 0 and ls_files_res.stdout:match("^160000") then
        local current_hash = vim.trim(vim.system({ "git", "rev-parse", (":%s"):format(relative_filepath) }):wait()
            .stdout)
        replace_with_scratch({ ("Submodule %s"):format(current_hash) }, "diff")
        return
    end

    -- For regular files, try to get the content from the ref.
    local show_result = vim.system({ "git", "show", ("%s:%s"):format(ref, relative_filepath) }):wait()
    if show_result.code ~= 0 then return end -- File is new in this ref, so do nothing.
    local lines = vim.split(show_result.stdout, "\n")
    if #lines > 0 and lines[#lines] == "" then table.remove(lines) end

    if not vim.fn.filereadable(filepath) then
        create_scratch_split(lines)
        vim.cmd("diffthis")
        vim.cmd("wincmd p")
        replace_with_scratch({})
        vim.cmd("diffthis")
    else
        create_scratch_split(lines)
        vim.cmd("diffthis")
        vim.cmd("wincmd p")
        vim.cmd("diffthis")
    end
end

vim.api.nvim_create_user_command(
    "GitDiff",
    function(cmd) git_diff(cmd.fargs[1]) end,
    { nargs = "*", desc = "Diff current buffer with given Git ref" }
)

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>gd", git_diff, opts)
vim.keymap.set("n", "<leader>gD", function()
    local ref = vim.fn.input("ref> ")
    git_diff(ref)
end, opts)

vim.keymap.set("n", "gh", function() vim.cmd.diffget "LOCAL" end, opts)
vim.keymap.set("n", "gl", function() vim.cmd.diffget "REMOTE" end, opts)
