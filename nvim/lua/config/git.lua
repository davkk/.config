---@param ref string | nil
local function git_diff(ref)
    ref = ref or "HEAD"

    local cwd = vim.fn.getcwd()
    local filepath = vim.fn.expand("%:p"):sub(#cwd + 2)

    local track = vim.system({ "git", "ls-files", "--error-unmatch", filepath }):wait()
    local is_tracked = track.code == 0

    local content
    if is_tracked then
        local show = vim.system({ "git", "show", ("%s:%s"):format(ref, filepath) }):wait()
        if show.code ~= 0 then
            return
        end
        content = show.stdout
    end

    vim.cmd [[leftabove vsplit]]

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].filetype = vim.bo.filetype
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"

    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content or "", "\n"))

    vim.bo[buf].modifiable = false

    vim.cmd.diffthis()
    vim.cmd.wincmd "p"
    vim.cmd.diffthis()
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
