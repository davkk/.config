return {
    "Saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
    version = "v0.*",
    config = function()
        require("blink.cmp").setup({
            keymap = {
                ["<C-n>"] = { "show", "select_next", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up" },
                ["<C-d>"] = { "scroll_documentation_down" },
            },
            completion = {
                menu = {
                    winblend = 5,
                    draw = {
                        columns = {
                            { "label",      "label_description" },
                            { "kind_icon",  gap = 1,            "kind" },
                            { "source_name" }
                        },
                        components = {
                            source_name = {
                                text = function(ctx)
                                    return ({
                                        LSP = "[LSP]",
                                        Buffer = "[BUF]",
                                        Path = "[PATH]",
                                        Snippets = "[SNIP]",
                                    })[ctx.source_name] or ctx.source_name
                                end,
                            }
                        }
                    },
                },
                documentation = { auto_show = true },
                ghost_text = { enabled = true },
            },
            signature = { enabled = true },
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
            },
        })
    end,
}
