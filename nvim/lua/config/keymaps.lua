vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

vim.keymap.set({ "n", "v" }, "<leader>p", '"_dP', opts)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], opts)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], opts)
vim.keymap.set("n", "<leader>Y", [["+Y]], opts)

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

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

vim.keymap.set("n", "<A-Right>", "<C-w>5>", opts)
vim.keymap.set("n", "<A-Left>", "<C-w>5<", opts)
vim.keymap.set("n", "<A-Up>", "<C-w>2+", opts)
vim.keymap.set("n", "<A-Down>", "<C-w>2-", opts)

vim.keymap.set({ "n", "v" }, "k",
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true }
)
vim.keymap.set({ "n", "v" }, "j",
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true }
)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", opts)
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", opts)

vim.keymap.set("n", "<left>", "gT", opts)
vim.keymap.set("n", "<right>", "gt", opts)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<S-Space>", "<Space>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>st", function()
    vim.cmd.new()
    vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.3))
    vim.wo.winfixheight = true
    vim.cmd.term()
end)
