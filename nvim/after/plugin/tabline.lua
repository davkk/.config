Tabline = {}

function Tabline.build_tabline()
    local line = ""
    for idx = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(idx)
        local buflist = vim.fn.tabpagebuflist(idx)
        local bufnr = buflist[winnr]
        local bufname = vim.fn.bufname(bufnr)

        line = line .. "%" .. idx .. "T"

        if idx == vim.fn.tabpagenr() then
            line = line .. "%#TabLineSel#"
        else
            line = line .. "%#TabLine#"
        end

        line = line .. idx .. ":"

        line = line .. "["
        if bufname ~= "" then
            line = line .. vim.fn.fnamemodify(bufname, ":t")
        else
            line = line .. "[No Name]"
        end
        line = line .. "]"
        line = line .. " "
    end

    line = line .. "%#TabLineFill#"
    return line
end

vim.opt.tabline = "%!v:lua.Tabline.build_tabline()"
