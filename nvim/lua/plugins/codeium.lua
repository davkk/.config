return {
    "Exafunction/codeium.nvim",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "nvim-lua/plenary.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("codeium").setup({})

        vim.keymap.set("i", "<tab>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true })

        vim.keymap.set("i", "<c-x>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true })

        vim.cmd [[
            let g:codeium_idle_delay = 300
            let g:codeium_manual = v:true
        ]]
    end
}
