vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- general
keymap.set('n', '<leader>nh', ':nohl<CR>', opts)

keymap.set('n', 'x', '"_x', opts)
keymap.set('x', '<leader>p', '"_dP', opts)

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

keymap.set('n', '+', '<C-a>', opts)
keymap.set('n', '-', '<C-x>', opts)

keymap.set('n', '<C-d>', '<C-d>zz', opts)
keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- resize window
keymap.set('n', '<C-left>', '<C-w>3>', opts)
keymap.set('n', '<C-right>', '<C-w>3<', opts)
keymap.set('n', '<C-up>', '<C-w>3+', opts)
keymap.set('n', '<C-down>', '<C-w>3-', opts)

-- better experience
keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- exit teminal with Esc
keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- quickfix list navigation
keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- terminal
keymap.set("n", "<leader>t", "<cmd>term<cr>", opts)
keymap.set("n", "<leader>st", "<cmd>12 split<cr>:se wfh<cr>:term<cr>", opts)
keymap.set("n", "<leader>vst", "<cmd>45 vsplit<cr>:se wfw<cr>:term<cr>", opts)

-- tabs
keymap.set('n', "<C-t>", "<Nop>", opts) -- disable default tagstack keymap
keymap.set('n', "<C-t>n", "<cmd>tabnew<CR>", opts)
keymap.set('n', "<C-t>t", "<cmd>tabnew<CR>:term<CR>", opts)

keymap.set('n', "<C-t>c", "<cmd>tabclose<CR>", opts)

for i = 1, 9 do
    keymap.set("n", string.format("<C-t>%i", i), function()
        pcall(vim.cmd, [[checktime]])
        vim.api.nvim_feedkeys(string.format("%sgt", i), "n", true)
    end, { desc = string.format("Switch to tab nr %s", i), silent = true, noremap = true })
end

keymap.set("n", "<C-f>", ":$tabnew<cr>:term<cr>i<C-f>", opts)
