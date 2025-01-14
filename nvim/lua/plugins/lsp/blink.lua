return {
    "Saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = {
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
                        { "label", "label_description" }, { "kind_icon", gap = 1, "kind" }, { "source_name" }
                    },
                    components = {
                        source_name = {
                            text = function(ctx)
                                return ({
                                    LSP = "[LSP]",
                                    Buffer = "[BUF]",
                                    cmdline = "[CMD]",
                                    Path = "[PATH]",
                                    Snippets = "[SNIP]",
                                })[ctx.source_name] or string.format("[%s]", ctx.source_name:upper())
                            end,
                        }
                    }
                },
            },
            accept = { auto_brackets = { enabled = false } },
            documentation = { auto_show = true },
            ghost_text = { enabled = true },
        },
    },
}
