return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local parser = require("lint.parser")
        local util = require("lspconfig.util")

        lint.linters.o2_linter = {
            cmd = "python",
            stdin = false,
            args = { vim.env.HOME .. "/work/alice/O2Physics/Scripts/o2_linter.py" },
            stream = "stdout",
            ignore_exitcode = true,
            parser = parser.from_pattern(
                "(.+):(%d+):(.+)",
                { "file", "lnum", "message" },
                nil,
                { source = "o2_linter", severity = vim.diagnostic.severity.INFO }
            )
        }

        lint.linters_by_ft = {
            python = { "ruff" },
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            cmake = { "cmakelint" },
            cpp = { "o2_linter", "cpplint" }
        }

        local root_patterns = {
            ruff = { "pyproject.toml", "ruff.toml", ".ruff.toml" },
            eslint_d = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" },
            biomejs = { "biome.json" },
            o2_linter = { "PWGCF", ".mega-linter.yml" },
            cpplint = { "CPPLINT.cfg" },
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
                            return util.root_pattern(unpack(root_patterns[name]))(args.file) ~= nil
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
