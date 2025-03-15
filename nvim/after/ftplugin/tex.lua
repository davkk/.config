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

local nbs = " "
local words = { "in", "of", "and", "or", "a", "the", "w", "oraz", "i", "do", "od", "na", "e.g.,", "as", "by" }
local group = vim.api.nvim_create_augroup("UserTex", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = 0,
    callback = function()
        for _, word in pairs(words) do
            vim.cmd(string.format([[ silent %%s/\(\<%s\>\) /\1%s/ge ]], word, nbs))
        end
        vim.cmd(string.format([[ silent %%s/ \(\[.\{-}]\)/%s\1/ge ]], nbs))
    end
})
