local severities = {
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.ERROR,
}

return {
    cmd = {
        "eslint_d",
        "--format=json",
        function() return vim.fn.expand("%:p") end,
    },
    pattern = { "*.ts", "*.js", "*.jsx", "*.tsx" },
    parser = function(_, output)
        local decode_opts = { luanil = { object = true, array = true } }
        local ok, data = pcall(vim.json.decode, output, decode_opts)
        if not ok then
            return {}
        end

        ---@type vim.Diagnostic[]
        local diagnostics = {}
        for _, result in ipairs(data or {}) do
            for _, msg in ipairs(result.messages or {}) do
                table.insert(diagnostics, {
                    lnum = msg.line and (msg.line - 1) or 0,
                    end_lnum = msg.endLine and (msg.endLine - 1) or nil,
                    col = msg.column and (msg.column - 1) or 0,
                    end_col = msg.endColumn and (msg.endColumn - 1) or nil,
                    message = msg.message,
                    code = msg.ruleId,
                    severity = severities[msg.severity],
                    source = "eslint_d",
                })
            end
        end

        return diagnostics
    end,
    enabled = function(bufnr)
        return vim.fs.root(bufnr, {
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.json",
            ".eslint-ts-config"
        }) ~= nil
    end,
}
