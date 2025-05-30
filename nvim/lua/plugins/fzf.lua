local fzf = require("fzf-lua")
local defaults = require("fzf-lua.config").defaults
local actions = require("fzf-lua.actions")

fzf.setup {
    "fzf-native",
    fzf_opts = { ["--layout"] = "default" },
    winopts = {
        width = 1,
        height = 0.6,
        row = 1,
        border = { " " },
        backdrop = 100,
        preview = {
            hidden = "hidden",
            default = "head",
            layout = "vertical",
            vertical = "up:40%",
        },
    },
    keymap = {
        fzf = {
            true,
            ["ctrl-c"] = "abort",
            ["ctrl-q"] = "select-all+accept",
            ["f3"] = "toggle-preview",
            ["f4"] = "toggle-preview-wrap",
        },
    },
    actions = {
        files = {
            true,
            ["ctrl-y"] = actions.file_edit_or_qf,
            ["ctrl-h"] = actions.file_vsplit,
        },
    },
    grep = { rg_opts = defaults.grep.rg_opts:sub(1, #defaults.grep.rg_opts - 2) .. [[--trim -e]] },
    helptags = { previewer = "help_native" },
}

vim.keymap.set(
    "n",
    "<C-f>",
    fzf.files,
    { desc = "find files" }
)

vim.keymap.set(
    "n",
    "<C-p>",
    fzf.git_files,
    { desc = "git files" }
)

vim.keymap.set(
    "n",
    "<leader>gw",
    fzf.grep_cword,
    { desc = "grep cword", }
)

vim.keymap.set(
    "n",
    "<leader>gW",
    fzf.grep_cWORD,
    { desc = "grep cWORD", }
)

vim.keymap.set(
    "v",
    "<leader>gw",
    fzf.grep_visual,
    { desc = "grep visual", }
)

vim.keymap.set(
    "n",
    "<leader>lg",
    fzf.live_grep_native,
    { desc = "live grep", }
)

vim.keymap.set(
    "n",
    "\\\\",
    fzf.buffers,
    { desc = "show buffers", }
)

vim.keymap.set(
    "n",
    "<leader>.",
    function() fzf.git_files({ cwd = "~/.config" }) end,
    { desc = "edit .config files", }
)

vim.keymap.set(
    "n",
    "<leader>/",
    fzf.blines,
    { desc = "buffer lines", }
)

vim.keymap.set(
    "n",
    "<F1>",
    fzf.helptags,
    { desc = "neovim help", }
)
