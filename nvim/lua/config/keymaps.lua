vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- general
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("x", "<leader>p", '"_dP', opts)

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- resize window
vim.keymap.set("n", "<A-Right>", "<C-w>5>", opts)
vim.keymap.set("n", "<A-Left>", "<C-w>5<", opts)
vim.keymap.set("n", "<A-Up>", "<C-w>2+", opts)
vim.keymap.set("n", "<A-Down>", "<C-w>2-", opts)

-- better experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set({ "n", "v" }, "k",
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true }
)
vim.keymap.set({ "n", "v" }, "j",
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true }
)

-- quickfix list navigation
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<S-Space>", "<Space>")

vim.keymap.set("n", "<leader>st", "<cmd>12 split<cr>:se wfh<cr>:term<cr>", opts)

vim.keymap.set("n", "<Right>", function()
    pcall(vim.cmd, [[checktime]])
    vim.api.nvim_feedkeys("gt", "n", true)
end, opts)

vim.keymap.set("n", "<Left>", function()
    pcall(vim.cmd, [[checktime]])
    vim.api.nvim_feedkeys("gT", "n", true)
end, opts)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc =
        "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

        local opts_buff = vim.tbl_extend("force", opts, { buffer = ev.buf })

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts_buff)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts_buff)
        vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts_buff)
        vim.keymap.set("n", "<leader>gI", vim.lsp.buf.implementation, opts_buff)
        vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts_buff)

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts_buff)

        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts_buff) -- open detailed error message window

        local get_highest_error_severity = function()
            local severity_levels = {
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.WARN,
                vim.diagnostic.severity.INFO,
                vim.diagnostic.severity.HINT,
            }
            for _, level in ipairs(severity_levels) do
                local diags = vim.diagnostic.get(0, {
                    severity = { min = level }
                })
                if #diags > 0 then
                    return level, diags
                end
            end
        end

        vim.keymap.set("n", "<leader>dn", function()
            vim.diagnostic.goto_next {
                severity = get_highest_error_severity(),
                wrap = true,
                float = true,
            }
        end, opts_buff)
        vim.keymap.set("n", "<leader>dp", function()
            vim.diagnostic.goto_prev {
                severity = get_highest_error_severity(),
                wrap = true,
                float = true,
            }
        end, opts_buff)

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts_buff)
        vim.keymap.set("n", "<leader>rr",
            "<cmd>:Telescope lsp_references<cr>",
            opts_buff)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_buff)

        vim.keymap.set("i", "<C-s>", function()
            require("cmp").mapping.abort()
            vim.lsp.buf.signature_help()
        end, opts_buff)
    end,
})
