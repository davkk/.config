return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
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
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local cmp_mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-y>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            })
            cmp_mapping['<Tab>'] = nil
            cmp_mapping['<S-Tab>'] = nil

            return {
                window = {
                    completion = cmp.config.window.bordered {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                        side_padding = 0,
                        col_offset = -2,
                    },
                    documentation = cmp.config.window.bordered {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                        side_padding = 0,
                        col_offset = -2,
                    }
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp_mapping,
                sources = cmp.config.sources({
                    {
                        name = "nvim_lsp",
                        group_index = 1,
                        max_item_count = 20,
                        keyword_length = 2,
                    },
                    { name = "buffer" },
                    { name = "luasnip" },
                    { name = "path" },
                }),
                performance = {
                    trigger_debounce_time = 300,
                    fetching_timeout = 80
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = require("lspkind").cmp_format({
                        mode = "symbol",
                        ellipsis_char = "…",
                        before = function(_, vim_item)
                            vim_item.abbr = vim_item.abbr:match("[^(]+")
                            return vim_item
                        end,
                        menu = {
                            buffer = "[buf]",
                            nvim_lsp = "[LSP]",
                            path = "[path]",
                            luasnip = "[snip]",
                        },
                    }),
                },
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")

            cmp.setup(opts)

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
