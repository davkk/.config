return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    keys = { "<leader>f" },
    opts = {
        formatters_by_ft = {
            python = { "ruff" },
            javascript = { "biome", "prettierd", "eslint_d" },
            javascriptreact = { "biome", "prettierd", "eslint_d" },
            typescript = { "biome", "prettierd", "eslint_d" },
            typescriptreact = { "biome", "prettierd", "eslint_d" },
            sass = { "prettierd" },
            scss = { "prettierd" },
            css = { "prettierd" },
            cmake = { "gersemi" },
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)

        vim.keymap.set(
            { "n", "v" },
            "<leader>f",
            function()
                conform.format({
                    timeout_ms = 4000,
                    async = true,
                    lsp_fallback = true,
                    quiet = true,
                })
            end,
            { desc = "Format buffer", }
        )
    end,
}
