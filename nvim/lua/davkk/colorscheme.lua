require("no-clown-fiesta").setup({
  transparent = true, -- Enable this to disable the bg color
  styles = { 
    -- You can set any of the style values specified for `:h nvim_set_hl`
    comments = {},
    keywords = {},
    functions = {},
    variables = {},
    type = { bold = true },
  },
})

vim.cmd("colorscheme no-clown-fiesta")

-- require("gruvbox").setup({
--     contrast = "hard", -- can be "hard", "soft" or empty string
--     transparent_mode = true,
--     italic = false,
--     dim_inactive = true,
-- })
--
-- vim.cmd("colorscheme gruvbox")

vim.opt.background = "dark"

vim.opt.termguicolors = true
