local winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"

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
                ["<Tab>"] = cmp.config.disable,
                ["<S-Tab>"] = cmp.config.disable,

                ["<C-Space>"] = cmp.mapping.complete(),

                ["<C-y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),
                ["<C-q>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),

                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            })

            return {
                window = {
                    completion = {
                        winhighlight = winhighlight,
                    },
                    documentation = {
                        winhighlight = winhighlight,
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
                    { name = "path" },
                    { name = "luasnip" },
                    {
                        name = "buffer",
                        keyword_length = 5,
                    },
                }),
                performance = {
                    trigger_debounce_time = 300,
                    fetching_timeout = 80
                },
                formatting = {
                    -- fields = { "kind", "abbr", "menu" },
                    format = require("lspkind").cmp_format({
                        -- mode = "symbol",
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
                }),
            })

            cmp.setup.cmdline({ ":" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
