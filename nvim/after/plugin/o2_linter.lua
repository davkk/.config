local cwd = vim.uv.cwd()
if cwd ~= nil and vim.fn.fnamemodify(cwd, ":t") ~= "O2Physics" then
    return
end

local group = vim.api.nvim_create_augroup("UserO2Linter", { clear = true })
local namespace = vim.api.nvim_create_namespace("o2_linter")

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    desc = "Run o2_linter on save",
    group = group,
    pattern = { "*.cxx", "*.cpp", "*.h", "*.hpp" },
    callback = function()
        local cmd = {
            "python",
            vim.env.HOME .. "/work/alice/O2Physics/Scripts/o2_linter.py",
            vim.fn.expand("%:p")
        }
        vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            on_stdout = function(_, data)
                local bufnr = vim.api.nvim_get_current_buf()
                local diagnostics = {}

                for _, line in ipairs(data) do
                    local file, lnum, message = string.match(line, "(.+):(%d+):(.+)")
                    if file and lnum and message then
                        lnum = tonumber(lnum) or 1
                        local content = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
                        table.insert(diagnostics, {
                            lnum = tonumber(lnum) - 1,
                            col = (string.find(content, "%S") or 1) - 1,
                            end_col = #content,
                            message = message,
                            source = "o2_linter",
                            severity = vim.diagnostic.severity.INFO,
                        })
                    end
                end

                vim.diagnostic.set(namespace, bufnr, diagnostics, {
                    underline = true,
                    virtual_text = true,
                    signs = true
                })
            end,
        })
    end,
})
