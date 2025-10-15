---@type Linter
return {
    cmd = {
        "vale",
        "--output=JSON",
        function()
            return vim.fn.expand "%:p"
        end,
    },
    pattern = { "*.md", "*.tex", "*.typ" },
    parser = function(bufnr, output)
        local decode_opts = { luanil = { object = true, array = true } }
        local json_ok, data = pcall(vim.json.decode, output, decode_opts)
        if not json_ok then
            return {}
        end

        data = data[vim.fn.expand "%:p"]

        ---@type vim.Diagnostic[]
        local diagnostics = {}
        for _, result in ipairs(data or {}) do
            local line = vim.api.nvim_buf_get_lines(bufnr, result.Line - 1, result.Line, false)[1]
            if not line then
                goto continue
            end

            local col_ok, column = pcall(vim.str_byteindex, line, result.Span[1])
            if not col_ok then
                column = 1
            end
            local ecol_ok, end_column = pcall(vim.str_byteindex, line, result.Span[2])
            if not ecol_ok then
                end_column = #line
            end

            table.insert(diagnostics, {
                lnum = result.Line - 1,
                col = column - 1,
                end_col = end_column,
                message = result.Message,
                code = result.Check,
                severity = vim.diagnostic.severity.INFO,
                source = "vale",
            })

            ::continue::
        end

        return diagnostics
    end,
    enabled = function(bufnr)
        return vim.fs.root(bufnr, {
            ".vale.ini",
            ".vale.toml",
        }) ~= nil
    end,
}
