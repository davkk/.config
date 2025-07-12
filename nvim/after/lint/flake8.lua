local severity = {
    F = vim.diagnostic.severity.INFO,
    E = vim.diagnostic.severity.ERROR,
    W = vim.diagnostic.severity.WARN,
}

vim.lint.config {
    cmd = {
        "flake8",
        function() return vim.fn.expand("%:p") end,
    },
    pattern = { "*.py" },
    parser = function(bufnr, output)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            local lnum, col, code, message = string.match(line, "[^:]+:(%d+):(%d+): (%w+) (.+)")
            if lnum and col and code and message then
                lnum = tonumber(lnum) or 1
                col = tonumber(col) or 1
                local content = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
                local indent = string.find(content, "%S")
                table.insert(diagnostics, {
                    lnum = tonumber(lnum) - 1,
                    col = (indent or 1) - 1,
                    end_col = #content,
                    message = message,
                    source = "flake8",
                    severity = severity[code:sub(1, 1)] or vim.diagnostic.severity.INFO,
                    code = code,
                })
            end
        end

        return diagnostics
    end,
    enabled = function()
        return vim.lint.find_cwd({
            ".flake8",
            ".flake8.ini",
        })
    end,
}
