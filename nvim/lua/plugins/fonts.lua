return {
    {
        "yamatsum/nvim-web-nonicons",
        requires = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("nvim-nonicons").setup()
        end,
    },
}
