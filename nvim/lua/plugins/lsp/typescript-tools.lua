return {
    "pmizio/typescript-tools.nvim",
    ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local lsp = require("davkk.lsp")
        lsp.server_setup(require("typescript-tools"), {
            settings = { expose_as_code_action = { "all" }, }
        })
    end,
}
