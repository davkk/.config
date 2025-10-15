local M = {}

local utils = require "core.utils"

---@class Linter
---@field cmd (string | fun(): string)[]
---@field pattern string[]
---@field stream string | nil
---@field parser fun(bufnr: integer, output: string): vim.Diagnostic[]
---@field enabled fun(bufnr: integer): boolean

---@param name string
---@param linter Linter
local function start_linter(name, linter)
    local namespace = vim.api.nvim_create_namespace("user.linter." .. name)

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        desc = name,
        group = vim.api.nvim_create_augroup("user.linter", { clear = false }),
        pattern = linter.pattern,
        callback = function(event)
            if not linter.enabled(event.buf) then
                return
            end

            ---@type string[]
            local cmd = utils.tbl_copy(linter.cmd)
            for idx, arg in ipairs(linter.cmd) do
                if type(arg) == "function" then
                    cmd[idx] = arg()
                end
            end

            if not vim.fn.executable(cmd[1]) then
                return
            end

            vim.system(
                cmd,
                { text = true },
                vim.schedule_wrap(function(output)
                    local stream = linter.stream and output[linter.stream] or output.stdout
                    if not stream then
                        vim.notify("Wrong stream specified in " .. name .. " config", vim.log.levels.ERROR)
                        return
                    end

                    local diagnostics = linter.parser(event.buf, stream)

                    vim.diagnostic.set(namespace, event.buf, diagnostics, {
                        underline = true,
                        virtual_text = true,
                        signs = true,
                    })
                end)
            )
        end,
    })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        desc = ("clear %s"):format(name),
        group = vim.api.nvim_create_augroup("user.linter.clear." .. name, { clear = true }),
        pattern = linter.pattern,
        callback = function(event)
            if linter.enabled(event.buf) then
                vim.diagnostic.set(namespace, event.buf, {})
            end
        end,
    })
end

---@param linters string[]
function M.enable(linters)
    for _, name in ipairs(linters) do
        local paths = vim.api.nvim_get_runtime_file(("lint/%s.lua"):format(name), true)
        for _, path in ipairs(paths) do
            local config = assert(loadfile(path))()
            if type(config) == "table" then
                start_linter(name, config)
            end
        end
    end
end

return M
