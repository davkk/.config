return {
    "ionide/Ionide-vim", -- F# support
    ft = { "fsharp", "fsproj" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        vim.cmd [[
            let g:fsharp#fsi_window_command = "botright vnew | lcd #:p:h"
            let g:fsharp#fsi_extra_parameters = ["--warn:5"]
            let g:fsharp#lsp_recommended_colorscheme = 0
            let g:fsharp#exclude_project_directories = ['paket-files']
            let g:fsharp#recommended_colorscheme = 0
        ]]

        local lspconfig = require("lspconfig")
        local lsp = require("davkk.lsp")

        lsp.server_setup(require("ionide"), {
            cmd = {
                "fsautocomplete",
                "--project-graph-enabled",
                "--adaptive-lsp-server-enabled",
            },
            root_dir = function(filename, _)
                local root
                root = lspconfig.util.find_git_ancestor(filename)
                root = root or lspconfig.util.root_pattern("*.sln")(filename)
                root = root or
                    lspconfig.util.root_pattern("*.fsproj")(filename)
                root = root or lspconfig.util.root_pattern("*.fsx")(filename)
                return root
            end,
        })

        -- change filetype of fsproj files
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
            command = "set ft=xml",
            pattern = { "*.fsproj" },
            group = vim.api.nvim_create_augroup("fsprojFtdetect",
                { clear = true })
        })

        -- change cwd on open .fsx files
        vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
            command = "lcd %:p:h",
            pattern = { "*.fsx" },
        })
    end
}
