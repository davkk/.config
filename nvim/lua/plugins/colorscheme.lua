return {
    {
        'ellisonleao/gruvbox.nvim',
        opts = {
            contrast = "hard", -- can be "hard", "soft" or empty string
            transparent_mode = true,
            italic = false,
            dim_inactive = true,
        }
    },
    {
        'aktersnurra/no-clown-fiesta.nvim',
        opts = {
            transparent = true, -- Enable this to disable the bg color
            styles = { 
                -- You can set any of the style values specified for `:h nvim_set_hl`
                comments = {},
                keywords = {},
                functions = {},
                variables = {},
                type = { bold = true },
            },
        }
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
        opts = {
            dark_variant = 'main',
            bold_vert_split = true,
            dim_nc_background = true,
            disable_background = true,
            disable_float_background = true,
            disable_italics = true,
        },
        config = function(_, opts) 
            require("rose-pine").setup(opts)
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
}
