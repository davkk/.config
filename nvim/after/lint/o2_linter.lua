return {
    cmd = {
        "python",
        function()
            return vim.fs.joinpath(vim.uv.cwd(), "Scripts", "o2_linter.py")
        end,
        function()
            return vim.fn.expand "%:p"
        end,
    },
    pattern = { "*.c", "*.C", "*.cxx", "*.cpp", "*.h", "*.hpp" },
    parser = function(bufnr, output)
        local diagnostics = {}

        local ok, lines = pcall(vim.split, output, "\n")
        if not ok then
            return diagnostics
        end

        for _, line in ipairs(lines) do
            local file, lnum, message = string.match(line, "(.+):(%d+):(.+)")
            if file and lnum and message then
                lnum = tonumber(lnum) or 1
                local content = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
                local indent = string.find(content, "%S")
                table.insert(diagnostics, {
                    lnum = tonumber(lnum) - 1,
                    col = (indent or 1) - 1,
                    end_col = #content,
                    message = message,
                    source = "o2_linter",
                    severity = vim.diagnostic.severity.INFO,
                })
            end
        end

        return diagnostics
    end,
    enabled = function()
        local cwd = vim.uv.cwd()
        return not cwd or not vim.fn.fnamemodify(cwd, ":t") ~= "O2Physics"
    end,
}
