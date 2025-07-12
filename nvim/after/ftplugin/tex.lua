local set = vim.opt_local
set.wrap = true
set.spell = true
set.spelllang = { "en", "pl" }

vim.g.tex_flavor = "latex"

vim.snippet.add("fig", [[
\begin{figure}[ht!]
    \centering
    \caption{${2}}
    \includegraphics[width=\textwidth]{${1}}
\end{figure}
]], { buffer = 0 })

local group = vim.api.nvim_create_augroup("user.tex", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = 0,
    callback = function()
        vim.cmd.Orphans()
    end
})
