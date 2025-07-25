return {
    cmd = {
        "cpplint",
        "--quiet",
        function() return vim.fn.expand("%:p") end,
    },
    pattern = { "*.c", "*.C", "*.cxx", "*.cpp", "*.h", "*.hpp" },
    stream = "stderr",
    parser = function(bufnr, output)
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
            local lnum, message, code = string.match(line, "[^:]+:(%d+):  (.+)  (.+)")
            if lnum and message then
                lnum = tonumber(lnum) or 1
                local content = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
                local indent = string.find(content, "%S")
                table.insert(diagnostics, {
                    lnum = tonumber(lnum) - 1,
                    col = (indent or 1) - 1,
                    end_col = #content,
                    message = message,
                    source = "cpplint",
                    severity = vim.diagnostic.severity.INFO,
                    code = code,
                })
            end
        end
        return diagnostics
    end,
    enabled = function(bufnr)
        return vim.fs.root(bufnr, {
            ".cpplint",
            ".cpplint.yml",
            ".cpplint.yaml",
            ".mega-linter.yml"
        }) ~= nil
    end,
}
