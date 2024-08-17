return {
    "ibhagwan/fzf-lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        local actions = require "fzf-lua.actions"

        fzf.setup({
            "fzf-native",
            fzf_opts = { ["--layout"] = "default" },
            winopts = {
                backdrop = 10,
                preview = {
                    default = "head",
                    hidden = "hidden",
                },
            },
            keymap = {
                fzf = {
                    ["ctrl-c"] = "abort",
                    ["ctrl-u"] = "half-page-up",
                    ["ctrl-d"] = "half-page-down",
                    ["f2"] = "toggle-preview",
                },
            },
            actions = {
                files = {
                    ["enter"] = actions.file_edit_or_qf,
                    ["ctrl-y"] = actions.file_edit_or_qf,
                    ["ctrl-x"] = actions.file_split,
                    ["ctrl-v"] = actions.file_vsplit,
                    ["ctrl-t"] = actions.file_tabedit,
                    ["ctrl-q"] = actions.file_sel_to_qf,
                },
            },
            helptags = { previewer = "help_native" },
        })

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
            "n",
            "<leader>lg",
            fzf.live_grep_resume,
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
    end
}
