---@class Lint
---@field config fun(opts: Opts): nil
---@field enable fun(linters: string[]): nil
vim.lint = {}

---@class Opts
---@field cmd (string | fun(): string)[]
---@field pattern string[]
---@field stream string | nil
---@field parser fun(bufnr: integer, output: string): vim.Diagnostic[]
---@field enabled fun(bufnr: integer): boolean

---@param opts Opts
function vim.lint.config(opts)
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        desc = opts.cmd[1] .. " linter",
        group = vim.api.nvim_create_augroup("user.linter", { clear = false }),
        pattern = opts.pattern,
        callback = function(args)
            if not opts.enabled(args.buf) then
                return
            end

            ---@type string[]
            local cmd = opts.cmd
            for idx, arg in ipairs(opts.cmd) do
                if type(arg) == "function" then
                    cmd[idx] = arg()
                end
            end

            if not vim.fn.executable(cmd[1]) then
                return
            end

            vim.system(opts.cmd, { text = true }, vim.schedule_wrap(function(output)
                local stream = opts.stream and output[opts.stream] or output.stdout
                if not stream then
                    vim.notify("Wrong stream specified in " .. opts.cmd[1] .. " config", vim.log.levels.ERROR)
                    return
                end

                local diagnostics = opts.parser(args.buf, stream)

                local namespace = vim.api.nvim_create_namespace("user.linter." .. opts.cmd[1])
                vim.diagnostic.set(namespace, args.buf, diagnostics, {
                    underline = true,
                    virtual_text = true,
                    signs = true,
                })
            end))
        end
    })
end

---@param markers string[]
function vim.lint.find_cwd(markers)
    local cwd = vim.uv.cwd()
    local has_marker = false
    for _, marker in ipairs(markers) do
        local filepath = vim.fs.joinpath(cwd, marker)
        if vim.uv.fs_stat(filepath) then
            has_marker = true
            break
        end
    end
    return has_marker
end

---@param linters string[]
function vim.lint.enable(linters)
    local runtimepaths = vim.split(vim.o.runtimepath, ",")
    for _, name in ipairs(linters) do
        for _, rtp in ipairs(runtimepaths) do
            local filepath = vim.fs.joinpath(rtp, "lint", name .. ".lua")
            if vim.uv.fs_stat(filepath) then
                dofile(filepath)
            end
        end
    end
end

vim.lint.enable({
    "eslint_d",
    "o2_linter",
    "cpplint",
    "flake8",
    "vale",
})
