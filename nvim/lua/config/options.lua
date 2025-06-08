vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

vim.o.relativenumber = true
vim.o.number = true

vim.o.laststatus = 3
vim.o.signcolumn = "yes"

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.breakindent = true
vim.o.linebreak = true
vim.o.wrap = false

vim.opt.formatoptions:remove "o"
vim.opt.formatoptions:remove "t"

vim.o.inccommand = "split"
vim.o.smartcase = true
vim.o.ignorecase = true

vim.opt.clipboard:append "unnamedplus"

vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.iskeyword:append "-"
vim.opt.isfname:append "@-@"

vim.o.updatetime = 50

vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false

vim.opt.shortmess:append "c"

vim.o.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    extends = "→",
    precedes = "←",
    conceal = "┊",
    nbsp = "␣",
}

vim.opt.diffopt:append "linematch:60"
vim.opt.diffopt:append "algorithm:histogram"

vim.opt.guicursor:append("t:ver100")

vim.opt.winborder = "solid"
