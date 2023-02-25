return {
    {
        "tpope/vim-fugitive",
        event = "BufReadPost",
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = true,
    },
}
