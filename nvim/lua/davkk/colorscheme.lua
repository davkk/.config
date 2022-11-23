require("gruvbox").setup({
    contrast = "hard", -- can be "hard", "soft" or empty string
    transparent_mode = true,
    italic = false,
    dim_inactive = true,
})

vim.cmd("colorscheme gruvbox")

vim.opt.background = "dark"

vim.opt.termguicolors = true
