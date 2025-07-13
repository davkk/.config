local M = {}

---@class Linter
---@field cmd (string | fun(): string)[]
---@field pattern string[]
---@field stream string | nil
---@field parser fun(bufnr: integer, output: string): vim.Diagnostic[]
---@field enabled fun(bufnr: integer): boolean

---@param linter Linter
local function start_linter(linter)
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        desc = linter.cmd[1] .. " linter",
        group = vim.api.nvim_create_augroup("user.linter", { clear = false }),
        pattern = linter.pattern,
        callback = function(args)
            if not linter.enabled(args.buf) then
                return
            end

            ---@type string[]
            local cmd = linter.cmd
            for idx, arg in ipairs(linter.cmd) do
                if type(arg) == "function" then
                    cmd[idx] = arg()
                end
            end

            if not vim.fn.executable(cmd[1]) then
                return
            end

            vim.system(linter.cmd, { text = true }, vim.schedule_wrap(function(output)
                local stream = linter.stream and output[linter.stream] or output.stdout
                if not stream then
                    vim.notify("Wrong stream specified in " .. linter.cmd[1] .. " config", vim.log.levels.ERROR)
                    return
                end

                local diagnostics = linter.parser(args.buf, stream)

                local namespace = vim.api.nvim_create_namespace("user.linter." .. linter.cmd[1])
                vim.diagnostic.set(namespace, args.buf, diagnostics, {
                    underline = true,
                    virtual_text = true,
                    signs = true,
                })
            end))
        end
    })
end

---@param linters string[]
function M.enable(linters)
    for _, name in ipairs(linters) do
        local paths = vim.api.nvim_get_runtime_file(("lint/%s.lua"):format(name), true)
        for _, path in ipairs(paths) do
            local config = assert(loadfile(path))()
            if type(config) == "table" then
                start_linter(config)
            end
        end
    end
end

return M
