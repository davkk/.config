return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",

        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = {
                ["<Tab>"] = cmp.config.disable,
                ["<S-Tab>"] = cmp.config.disable,

                ["<C-n>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        cmp.complete()
                    end
                end),
                ["<C-p>"] = cmp.mapping.select_prev_item({
                    behavior = cmp.SelectBehavior.Select
                }),

                ["<C-y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),
                ["<C-q>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),

                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp", group_index = 1 },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer" },
            }),
            performance = {
                trigger_debounce_time = 300,
                fetching_timeout = 80
            },
            formatting = {
                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = "[LSP]",
                        luasnip = "[SNIP]",
                        buffer = "[BUF]",
                        path = "[PATH]",
                    }
                    item.menu = menu_icon[entry.source.name]
                    return item
                end,
            },
            experimental = {
                ghost_text = true,
            },
        })
    end,
}
