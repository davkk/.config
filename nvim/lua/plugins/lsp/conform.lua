return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>f",
            function()
                require("conform").format({
                    timeout_ms = 4000,
                    async = true,
                    lsp_fallback = true
                })
            end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
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
    end,
}
