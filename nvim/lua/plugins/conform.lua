---@param names string[]
local has_in_root = function(names)
    return function(self, ctx)
        local util = require("conform.util")
        return util.root_file(names)(self, ctx)
    end
end

return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            python = { "ruff_format", "ruff_organize_imports" },
            javascript = { "biome", "prettierd", "eslint_d" },
            javascriptreact = { "biome", "prettierd", "eslint_d" },
            typescript = { "biome", "prettierd", "eslint_d" },
            typescriptreact = { "biome", "prettierd", "eslint_d" },
            sass = { "prettierd" },
            scss = { "prettierd" },
            css = { "prettierd" },
            cmake = { "gersemi" },
            zig = { "zigfmt" },
        },
        formatters = {
            eslint_d = {
                condition = has_in_root { ".eslintrc", ".eslintrc.js", "eslint.config.js" },
            },
            prettierd = {
                condition = has_in_root { ".prettierrc", ".prettierrc.js", "prettier.config.js" },
            },
            biome = {
                condition = has_in_root { "biome.json" },
            },
        }
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
