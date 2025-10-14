local utils = require "core.utils"

---@class format.Formatter
---@field cmd (string | fun(bufnr: integer): string)[]
---@field enabled fun(bufnr: integer): boolean

---@param bufnr integer
---@param hunks integer[][]
---@param formatted string[]
local function apply_hunks(bufnr, hunks, formatted)
    for i = #hunks, 1, -1 do
        local fi, fc, ti, tc = unpack(hunks[i])

        local new_lines = {}
        for j = ti, ti + tc - 1 do
            table.insert(new_lines, formatted[j])
        end

        vim.api.nvim_buf_set_lines(bufnr, fi - 1, fi + fc - 1, false, new_lines)
    end
end

---@param formatter format.Formatter
---@return boolean
local function format(formatter, bufnr)
    if not formatter.enabled(bufnr) then
        return false
    end

    ---@type string[]
    local cmd = utils.tbl_copy(formatter.cmd)
    for idx, arg in ipairs(formatter.cmd) do
        if type(arg) == "function" then
            cmd[idx] = arg(bufnr)
        end
    end

    if not vim.fn.executable(cmd[1]) then
        return false
    end

    local old_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local old_text = table.concat(old_lines, "\n")

    local sys_obj = vim.system(
        cmd,
        { text = true, stdin = true },
        vim.schedule_wrap(
        ---@param output vim.SystemCompleted
            function(output)
                if output.code == 0 and output.stdout then
                    local diff = vim.text.diff(old_text, output.stdout, {
                        algorithm = "histogram",
                        result_type = "indices",
                        ignore_whitespace_change_at_eol = true,
                    }) ---@cast diff integer[][]?

                    if diff and #diff > 0 then
                        local new_lines = vim.split(output.stdout, "\n", { trimempty = false })
                        apply_hunks(bufnr, diff, new_lines)
                    end
                end
            end
        )
    )

    sys_obj:write(old_text)
    sys_obj:write(nil)

    local ok, code = sys_obj:wait()
    if not ok then
        vim.notify(code or "Unknown error", vim.log.levels.ERROR)
        return false
    end

    return true
end

local function lsp_format_fallback(bufnr)
    bufnr = bufnr or 0
    local clients = vim.lsp.get_clients {
        bufnr = bufnr,
        method = "textDocument/formatting",
    }
    if #clients == 0 then
        vim.notify("No LSP clients available for formatting", vim.log.levels.WARN)
        return false
    end

    local params = vim.lsp.util.make_formatting_params()
    vim.lsp.buf_request(bufnr, "textDocument/formatting", params, function(err, result, ctx)
        if err or not result then
            vim.notify("LSP formatting failed", vim.log.levels.WARN)
            return
        end
        vim.lsp.util.apply_text_edits(
            result,
            ctx.bufnr,
            ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id).offset_encoding or "utf-8"
        )
        vim.cmd.redraw()
    end)
    return true
end

---@param bufnr integer
---@return string
local function get_relative_path(bufnr)
    local cwd = vim.fn.getcwd()
    local fullpath = vim.api.nvim_buf_get_name(bufnr)
    return fullpath:sub(#cwd + 2)
end

---@type format.Formatter[]
local formatters = {
    stylua = {
        cmd = {
            "stylua",
            "--stdin-filepath",
            function(bufnr)
                return get_relative_path(bufnr)
            end,
            "-",
        },
        enabled = function()
            return true
        end,
    },
    eslint_d = {
        cmd = {
            "eslint_d",
            "--fix-to-stdout",
            "--stdin",
            "--stdin-filename",
            function(bufnr)
                return get_relative_path(bufnr)
            end,
        },
        enabled = function()
            return true
        end,
    },
}

local formatters_by_ft = {
    lua = "stylua",
    javascript = "eslint_d",
    typescript = "eslint_d",
}

vim.keymap.set("n", "<leader>f", function()
    local bufnr = 0
    local ft = vim.bo[bufnr].filetype
    local formatter = formatters[formatters_by_ft[ft]]

    if not formatter then
        vim.notify("No formatter configured for " .. ft, vim.log.levels.WARN)
        return
    end

    if format(formatter, bufnr) and false then
        return
    end

    lsp_format_fallback(bufnr)
end, { desc = "format buffer" })
