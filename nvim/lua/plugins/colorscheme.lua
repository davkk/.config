return {
    dir = "~/.config/nvim/lua/plugins/custom/rose-pine-tinted",
    name = "rose-pine-tinted",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine-tinted").setup()
        vim.cmd([[colorscheme rose-pine-tinted]])
    end,
}
