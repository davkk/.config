return {
    {
        "quarto-dev/quarto-nvim",
        ft = "quarto",
        dependencies = {
            "jmbuhr/otter.nvim",
        },
        opts = {
            closePreviewOnExit = false,
            lspFeatures = {
                enabled = true,
                languages = { 'r', 'python', 'julia', 'bash' },
                chunks = 'curly', -- 'curly' or 'all'
                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" }
                },
                completion = {
                    enabled = true,
                },
            },
        },
        config = function(_, opts)
            require("quarto").setup(opts)
        end,
    }
}
