local status, telescope = pcall(require, "telescope")
if (not status) then return end

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup {
    defaults = {
        file_ignore_patterns = { '^.git/' },
        mappings = {
            i = {
                -- ['<esc>'] = actions.close,
                ['<C-q>'] = actions.send_to_qflist,
                ['<CR>'] = actions.select_default,
            },
            n = {
                ['q'] = actions.close,
            },
        },
    },
    extensions = {
        file_browser = {
            theme = 'dropdown',
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            file_ignore_patterns = { '^.git/' },
            mappings = {
                ['n'] = {
                    ['N'] = fb_actions.create,
                    ['h'] = fb_actions.goto_parent_dir,
                    ['/'] = function()
                        vim.cmd('startinsert')
                    end
                },
            },
        },
    },
}

telescope.load_extension('file_browser')

vim.keymap.set('n', '<C-p>',
function()
    builtin.find_files({
        hidden = true,
        theme = 'dropdown',
        grouped = true,
        previewer = false,
        layout_config = { height = 40 },
    })
end)

vim.keymap.set('n', '\\\\', function()
  builtin.buffers()
end)

vim.keymap.set('n', ';;', function()
  builtin.resume()
end)

vim.keymap.set('n', '<C-e>', function()
    telescope.extensions.file_browser.file_browser({
        path = '%:p:h',
        cwd = telescope_buffer_dir(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        initial_mode = 'normal',
    })
end)
