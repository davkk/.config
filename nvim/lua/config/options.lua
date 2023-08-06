local opt = vim.opt

-- colors
opt.background = "dark"
opt.termguicolors = true

-- file encoding
opt.fileencoding = "utf-8"

-- line numbers
opt.relativenumber = true
opt.number = true

-- winbar
opt.winbar = "%m %t"

-- global statusline
opt.laststatus = 3
opt.showmode = false

-- tabs and indent
opt.autoindent = true
opt.cindent = true
opt.wrap = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

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

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
        ['+'] = 'win32yank -i --crlf',
        ['*'] = 'win32yank -i --crlf',
    },
    paste = {
        ['+'] = 'win32yank -o --lf',
        ['*'] = 'win32yank -o --lf',
    },
    cache_enabled = 0,
}

-- force splits
opt.splitright = true
opt.splitbelow = true

-- word with dashes
opt.iskeyword:append("-")

-- mark 80th column
-- opt.colorcolumn = "80"

-- faster completion
opt.updatetime = 50

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

-- save undo history
opt.undofile = true

-- show whitespace
opt.list = true
opt.listchars = {
     tab = '»·',
     trail = '·',
     extends = '→',
     precedes = '←',
     conceal = '┊',
     nbsp = '␣',
}
