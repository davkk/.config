vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.wo.foldtext = ""

local opt = vim.opt

opt.shell = "/usr/bin/zsh"

opt.relativenumber = true
opt.number = true

opt.laststatus = 3
opt.signcolumn = "yes"

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.breakindent = true
opt.linebreak = true
opt.wrap = false

opt.formatoptions:remove "o"
opt.formatoptions:remove "t"

opt.inccommand = "split"
opt.smartcase = true
opt.ignorecase = true

opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append "-"
opt.isfname:append "@-@"

opt.updatetime = 50

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.errorbells = false

opt.shortmess:append "c"
opt.more = false

opt.completeopt = { "menu", "menuone", "noinsert", "popup", "fuzzy" }
opt.pumheight = 10

opt.list = true
opt.listchars = {
    tab = "» ",
    trail = "·",
    extends = "→",
    precedes = "←",
    conceal = "┊",
    nbsp = "␣",
}

opt.diffopt:append "algorithm:histogram"

opt.guicursor = vim.o.guicursor .. ",t:blinkon0-TermCursor"
