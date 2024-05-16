vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local opt = vim.opt

opt.shell = "/usr/bin/zsh"

opt.mouse = nil
opt.fileencoding = "utf-8"

opt.background = "dark"
opt.termguicolors = true

opt.relativenumber = true
opt.number = true

opt.showmode = true
opt.laststatus = 3
opt.cmdheight = 1

opt.cursorline = true

opt.scrolloff = 10
opt.sidescrolloff = 10

opt.autoindent = true
opt.cindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true
opt.wrap = false

vim.wo.foldtext = ""
opt.fo:remove("t")

opt.inccommand = 'split'
opt.smartcase = true
opt.ignorecase = true

opt.backspace = { "indent", "eol", "start" }

opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
opt.isfname:append("@-@")

opt.colorcolumn = "80"
opt.signcolumn = "yes"

opt.updatetime = 50

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.errorbells = false

opt.shortmess:append("c")

opt.completeopt = { "menu", "menuone", "noselect" }

opt.shada = { "'10", "<0", "s10", "h" }

opt.list = true
opt.listchars = {
    tab = '» ',
    trail = '·',
    extends = '→',
    precedes = '←',
    conceal = '┊',
    nbsp = '␣',
}

opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore

opt.joinspaces = false

opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "algorithm:minimal"
}
