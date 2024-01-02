local winhighlight =
"Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"

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
            local lspkind = require("lspkind")
            local cmp = require("cmp")

            return {
                window = {
                    completion = { winhighlight = winhighlight, },
                    documentation = { winhighlight = winhighlight, }
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
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

                    ["<C-p>"] = cmp.mapping.select_prev_item({
                        behavior = cmp
                            .SelectBehavior.Select
                    }),
                    ["<C-n>"] = cmp.mapping.select_next_item({
                        behavior = cmp
                            .SelectBehavior.Select
                    }),

                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                }),
                sources = cmp.config.sources({
                    {
                        name = "nvim_lsp",
                        group_index = 1,
                        max_item_count = 20,
                        keyword_length = 2,
                    },
                    { name = "path" },
                    { name = "luasnip" },
                    { name = "buffer", keyword_length = 5, },
                }),
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        -- better sort completion items that start with one or more underlines
                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label
                                :find "^_+"
                            local _, entry2_under = entry2.completion_item.label
                                :find "^_+"
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    }
                },
                performance = {
                    trigger_debounce_time = 300,
                    fetching_timeout = 80
                },
                formatting = {
                    format = lspkind.cmp_format({
                        ellipsis_char = "…",
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
