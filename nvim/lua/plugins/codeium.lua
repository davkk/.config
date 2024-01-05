return {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
        vim.keymap.set("i", "<tab>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true })

        vim.keymap.set("i", "<c-x>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true })

        vim.cmd [[
            let g:codeium_idle_delay = 600
        ]]
    end
}
