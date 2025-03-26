local conform = require("conform")

---@param names string[]
local has_in_root = function(names)
    return function(_, ctx)
        return vim.fs.root(ctx.filename, names)
    end
end

conform.setup {
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
    },
}

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
    { desc = "Format buffer" }
)
