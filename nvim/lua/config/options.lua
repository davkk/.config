local opt = vim.opt

-- disable mouse
opt.mouse = ""

-- colors
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- file encoding
opt.fileencoding = "utf-8"

-- title
opt.title = true

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.breakindent = true

-- text wrapping
opt.wrap = false

-- disable autowrapping
opt.fo:remove("t")

-- search
opt.ignorecase = true
opt.smartcase = true

-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- cursor line
opt.cursorline = true

-- apearance
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- force splits
opt.splitright = true
opt.splitbelow = true

-- word with dashes
opt.iskeyword:append("-")

-- mark 80th column
opt.colorcolumn = "80"

-- faster completion
opt.updatetime = 100

-- dont create swap file nor backup file
opt.swapfile = false
opt.backup = false

-- keep cursor at the center
opt.scrolloff = 10

-- disable bells
opt.errorbells = false

-- show sign column
opt.signcolumn = "yes"
opt.isfname:append("@-@")

-- more space for messages
opt.cmdheight = 1

-- Don't pass messages to |ins-completion-menu|. // not mine, borrowed 
opt.shortmess:append("c")

-- better experience
opt.completeopt = 'menuone,noselect'

-- show whitespace
opt.list = true

-- save undo history
opt.undofile = true

-- hide command-line when not used
opt.cmdheight = 0
