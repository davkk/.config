return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            null_ls.setup({
                sources = {
                    formatting.prettierd,
                    diagnostics.eslint_d.with({
                        -- only enable eslint if root has .eslintrc.js
                        condition = function(utils)
                            return utils.root_has_file(".eslintrc")
                                or utils.root_has_file(".eslintrc.js")
                                or utils.root_has_file(".eslintrc.ts")
                        end,
                    }),
                    formatting.black.with({
                        extra_args = { "--fast", "-l", "80" },
                    }),
                    formatting.isort,
                    formatting.rescript,
                }
            })
        end,
    }
}
