return {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        local actions = require("fzf-lua.actions")
        fzf.setup({
            "fzf-native",
            fzf_opts = { ["--layout"] = "default" },
            winopts = {
                width = 1,
                height = 0.6,
                row = 1,
                border = { " " },
                backdrop = 5,
                preview = {
                    hidden = "hidden",
                    default = "head",
                    layout = "vertical",
                    vertical = "up:40%",
                },
                on_create = function()
                    vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']],
                        { expr = true, buffer = true })
                end,
            },
            keymap = {
                fzf = {
                    true,
                    ["ctrl-c"] = "abort",
                    ["ctrl-u"] = "half-page-up",
                    ["ctrl-d"] = "half-page-down",
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
            files = { fd_opts = [[-c=never -t=f -H -L -I]] },
            grep = { rg_opts = [[--column -p -S --no-heading --trim -e]] },
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
    end
}
