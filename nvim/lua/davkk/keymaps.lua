vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- general
keymap.set('n', '<leader>nh', ':nohl<CR>', opts)

keymap.set('n', 'x', '"_x', opts)
keymap.set('x', '<leader>p', '"_dP', opts)

keymap.set('n', '+', '<C-a>', opts)
keymap.set('n', '-', '<C-x>', opts)

keymap.set('n', '<C-d>', '<C-d>zz', opts)
keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- netrw
keymap.set('n', '<C-e>', ':Ex<CR>', opts)

-- splits
keymap.set('n', '<leader>sv', '<C-w>v', opts)
keymap.set('n', '<leader>sh', '<C-w>s', opts)
keymap.set('n', '<leader>se', '<C-w>=', opts)
keymap.set('n', '<leader>sx', ':close<CR>', opts)

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
