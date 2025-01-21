-- FILE PATH
---@param path string
---@return string
local function shorten_path(path)
    local len = #path
    local max_len = vim.o.columns / 2

    local sep = package.config:sub(1, 1)

    if len <= max_len then
        return path
    end

    local segments = vim.split(path, sep)
    for idx = 1, #segments - 1 do
        if len <= max_len then
            break
        end

        local segment = segments[idx]
        local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
        segments[idx] = shortened
        len = len - (#segment - #shortened)
    end

    return table.concat(segments, sep)
end

---@return string
local function filepath()
    local path = vim.fn.expand("%:p:~")

    if #path == 0 then return "[No Name]" end

    path = shorten_path(path)

    local name = vim.fn.expand("%")
    local is_new_file = name ~= ""
        and vim.bo.buftype == ""
        and vim.fn.filereadable(name) == 0

    return "[" .. path .. (is_new_file and "][New]" or "]") .. "%r%m"
end

-- LSP DIAGNOSTICS
---@return string
local function lsp_diagnostics()
    local sev = vim.diagnostic.severity
    local levels = {
        error = sev.ERROR,
        warn = sev.WARN,
        info = sev.INFO,
        hint = sev.HINT,
    }

    local counts = {}
    for k, level in pairs(levels) do
        counts[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local error = ""
    local warn = ""
    local hint = ""
    local info = ""

    if counts.error > 0 then
        error = " %#DiagnosticSignError#E" .. counts.error
    end
    if counts.warn > 0 then
        warn = " %#DiagnosticSignWarn#W" .. counts.warn
    end
    if counts.hint > 0 then
        hint = " %#DiagnosticSignHint#H" .. counts.hint
    end
    if counts.info > 0 then
        info = " %#DiagnosticSignInfo#I" .. counts.info
    end

    return error .. warn .. hint .. info .. "%##"
end

-- CURSOR LOCATION
---@return string
local function location()
    local col = vim.fn.virtcol(".")
    local row = vim.fn.line(".")
    return string.format("[%3d:%-3d]", row, col)
end

-- GIT DIFF
---@return string
local function git_diff()
    return "%{get(b:,'gitsigns_status','')}"
end

-- LSP PROGRESS LOADER
local loader = { "∙  ", "∙∙ ", "∙∙∙", " ∙∙", "  ∙", "  " }
local loader_idx = 1
local loader_timer = nil
local lsp_loading = false

local function start_animation()
    if loader_timer then return end
    loader_timer = vim.uv.new_timer()
    loader_timer:start(0, 120, vim.schedule_wrap(function()
        if lsp_loading then
            loader_idx = (loader_idx % #loader) + 1
            vim.cmd [[redrawstatus]]
        end
    end))
end

local function stop_animation()
    if loader_timer then
        loader_timer:stop()
        loader_timer:close()
        loader_timer = nil
    end
    loader_idx = 1
end

---@return string
local function lsp_progress()
    if not lsp_loading and #vim.lsp.get_clients() > 0 then
        lsp_loading = true
        start_animation()
    end
    return lsp_loading and loader[loader_idx] or ""
end

vim.api.nvim_create_autocmd("LspProgress", {
    pattern = "*",
    callback = function(args)
        local value = args.data.params.value
        if value.kind == "begin" then
            lsp_loading = true
            start_animation()
        elseif value.kind == "end" then
            lsp_loading = false
            stop_animation()
            vim.cmd [[redrawstatus]]
        end
    end
})

StatusLine = {}

---@return string
function StatusLine.build_statusline()
    return table.concat({
        filepath(),
        "  ",
        git_diff(),
        "%=",
        lsp_loading and lsp_progress() or lsp_diagnostics(),
        "  ",
        location(),
    })
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave", "DiagnosticChanged" }, {
    group = vim.api.nvim_create_augroup("StatusLine", {}),
    callback = function()
        vim.opt.statusline = "%!v:lua.StatusLine.build_statusline()"
    end,
})
