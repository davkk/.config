local opt = vim.opt

opt.shell = "/usr/bin/zsh"

opt.mouse = nil

-- colors
opt.background = "dark"
opt.termguicolors = true

-- file encoding
opt.fileencoding = "utf-8"

-- line numbers
opt.relativenumber = true
opt.number = true

-- hide mode
opt.showmode = true

-- global statusline
opt.laststatus = 3

-- tabs and indent
opt.autoindent = true
opt.cindent = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

-- text wrapping
opt.wrap = false

-- transparent folds
vim.wo.foldtext = ""

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
opt.backspace = { "indent", "eol", "start" }

-- clipboard
opt.clipboard = "unnamedplus"

-- force splits
opt.splitright = true
opt.splitbelow = true

-- word with dashes
opt.iskeyword:append("-")

-- mark 80th column
opt.colorcolumn = "80"

-- faster completion
opt.updatetime = 50

-- dont create swap file nor backup file
opt.swapfile = false
opt.backup = false

-- keep cursor at the center
opt.scrolloff = 10
opt.sidescrolloff = 10

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
opt.completeopt = { "menu", "menuone", "noselect" }

-- save undo history
opt.undofile = true

-- show whitespace
opt.list = true
opt.listchars = {
    tab = '» ',
    trail = '·',
    extends = '→',
    precedes = '←',
    conceal = '┊',
    nbsp = '␣',
}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FormatOptionsGroup", {}),
    callback = function()
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
    end
})

opt.joinspaces = false -- Two spaces and grade school, we're done

opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "algorithm:minimal"
}
