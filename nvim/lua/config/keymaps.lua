vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- general
keymap.set('n', '<leader>nh', ':nohl<CR>', opts)

keymap.set('n', 'x', '"_x', opts)
keymap.set('x', '<leader>p', '"_dP', opts)

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

keymap.set('n', '<C-d>', '<C-d>zz', opts)
keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- resize window
keymap.set('n', '<A-Right>', '<C-w>5>', opts)
keymap.set('n', '<A-Left>', '<C-w>5<', opts)
keymap.set('n', '<A-Up>', '<C-w>2+', opts)
keymap.set('n', '<A-Down>', '<C-w>2-', opts)

-- better experience
keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- exit teminal with Esc
keymap.set('t', '<Esc>', '<C-\\><C-n>')
keymap.set('t', '<S-Space>', '<Space>')

-- quickfix list navigation
keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- terminal
keymap.set("n", "<leader>t", "<cmd>term<cr>", opts)
keymap.set("n", "<leader>st", "<cmd>12 split<cr>:se wfh<cr>:term<cr>", opts)

keymap.set("n", "L", function()
    pcall(vim.cmd, [[checktime]])
    vim.api.nvim_feedkeys("gt", "n", true)
end, { desc = "Switch to next tab", silent = true, noremap = true })

keymap.set("n", "H", function()
    pcall(vim.cmd, [[checktime]])
    vim.api.nvim_feedkeys("gT", "n", true)
end, { desc = "Switch to previous tab", silent = true, noremap = true })
