return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local util = require("lspconfig.util")

        lint.linters_by_ft = {
            python = { "ruff" },
        }

        local javascripts = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
        local eslint_configs = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
        for js in pairs(javascripts) do
            lint.linters_by_ft[js] = { "eslint_d" }
        end

        local lint_augroup = vim.api.nvim_create_augroup("Lint", { clear = true })
        vim.api.nvim_create_autocmd({
            "BufEnter", "BufWritePost", "InsertLeave", "TextChanged"
        }, {
            group = lint_augroup,
            callback = function(args)
                local ft = vim.bo.filetype

                if
                    vim.tbl_contains(javascripts, ft)
                    and util.root_pattern(eslint_configs)(args.file)
                then
                    lint.try_lint("eslint_d")
                else
                    lint.try_lint()
                end
            end
        })
    end
}
