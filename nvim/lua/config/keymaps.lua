vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- general
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("x", "<leader>p", '"_dP', opts)

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- recenter screen on jump
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "{", "{zz", opts)
vim.keymap.set("n", "}", "}zz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "*", "*zz", opts)
vim.keymap.set("n", "#", "#zz", opts)
vim.keymap.set("n", "g*", "g*zz", opts)
vim.keymap.set("n", "g#", "g#zz", opts)
vim.keymap.set("n", "gg", "ggzz", opts)
vim.keymap.set("n", "G", "Gzz", opts)
vim.keymap.set("n", "%", "%zz", opts)
vim.keymap.set("n", "<C-o>", "<C-o>zz", opts)
vim.keymap.set("n", "<C-i>", "<C-i>zz", opts)

-- move lines
vim.keymap.set("v", "<C-Left>", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "<C-Right>", ":m '>+1<CR>gv=gv", opts)

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


-- toggle diagnostics
vim.keymap.set(
    "n",
    "<leader>td",
    function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end
)
