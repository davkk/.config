return {
    "Exafunction/codeium.nvim",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "nvim-lua/plenary.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("codeium").setup({})

        vim.cmd [[
            let g:codeium_idle_delay = 300
            let g:codeium_manual = v:true
        ]]
    end
}
