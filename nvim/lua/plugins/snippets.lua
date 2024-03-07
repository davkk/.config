return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local ls = require("luasnip")
        require("luasnip.loaders.from_snipmate").lazy_load()

        ls.filetype_extend("javascript", { "jsdoc" })
        ls.filetype_extend("typescript", { "javascript" })

        vim.keymap.set({ "i" }, "<C-s>e", function() ls.expand() end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<C-s>k", function() ls.jump(-1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-s>j", function() ls.jump(1) end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<C-e>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true })
    end,
}
