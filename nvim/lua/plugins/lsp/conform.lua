return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    keys = { "<leader>f" },
    opts = {
        formatters_by_ft = {
            python = { "isort", "black" },
            javascript = { "prettierd", "eslint_d" },
            typescript = { "prettierd", "eslint_d" },
            sass = { "prettierd" },
            scss = { "prettierd" },
            css = { "prettierd" },
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        local util = require("conform.util")

        util.add_formatter_args(
            require("conform.formatters.black"),
            { "--fast", "-l", "80" }
        )

        util.add_formatter_args(
            require("conform.formatters.prettierd"),
            {
                "--print-width=80",
                "--tab-width=4",
            }
        )

        conform.setup(opts)

        vim.keymap.set(
            { "n", "v" },
            "<leader>f",
            function()
                conform.format({
                    timeout_ms = 4000,
                    async = true,
                    lsp_fallback = true
                })
            end,
            { desc = "Format buffer", }
        )
    end,
}
