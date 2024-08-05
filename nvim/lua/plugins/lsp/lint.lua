return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local util = require("lspconfig.util")

        local cppcheck = lint.linters.cppcheck
        table.insert(cppcheck.args, "--check-level=exhaustive")
        table.insert(cppcheck.args, "--suppress=missingIncludeSystem")
        table.insert(cppcheck.args, "--suppress=missingInclude")

        lint.linters_by_ft = {
            python = { "ruff" },
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            cpp = { "cppcheck" },
            cmake = { "cmakelint" },
        }

        local root_patterns = {
            ruff = { "pyproject.toml", "ruff.toml", ".ruff.toml" },
            eslint_d = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" },
            biomejs = { "biome.json" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("Lint", { clear = true })
        vim.api.nvim_create_autocmd({
            "BufEnter", "BufWritePost", "InsertLeave", "TextChanged"
        }, {
            group = lint_augroup,
            callback = function(args)
                local ft = vim.bo.filetype

                local linters = vim.tbl_filter(
                    function(name)
                        if root_patterns[name] then
                            return util.root_pattern(
                                unpack(root_patterns[name])
                            )(args.file)
                        else
                            return true
                        end
                    end,
                    lint._resolve_linter_by_ft(ft)
                )

                lint.try_lint(linters)
            end
        })
    end
}
