return {
    {
        -- Autocompletion,
        "hrsh7th/nvim-cmp",
        event = "BufReadPre",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",

            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            "onsails/lspkind-nvim",

            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")

            return {
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "luasnip" },
                    { name = "path" },
                }),
                performance = {
                    trigger_debounce_time = 500,
                    throttle = 550,
                    fetching_timeout = 80
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        with_text = false,
                        maxwidth = 30,
                        ellipsis_char = "...",
                    })
                }
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")

            cmp.setup(opts)

            vim.cmd [[
                highlight! default link CmpItemKind CmpItemMenuDefault
            ]]

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                })
            })

            cmp.setup.cmdline({ ":" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                })
            })
        end,
    },
}
