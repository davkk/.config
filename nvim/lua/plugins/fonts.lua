return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
    },
    {
        "yamatsum/nvim-web-nonicons",
        lazy = false,
        config = function()
            require("nvim-nonicons").setup()
        end,
    },
}
