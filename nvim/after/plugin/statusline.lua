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
local function filename()
    local path = vim.fn.expand("%:p:~")

    if #path == 0 then return "[No Name]" end

    path = shorten_path(path)

    local name = vim.fn.expand("%")
    local is_new_file = name ~= ""
        and vim.bo.buftype == ""
        and vim.fn.filereadable(name) == 0

    return "[" .. path .. (is_new_file and "][New]" or "]")
end

---@return string
local function lsp()
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

    return error .. warn .. hint .. info .. "%#LineNr#"
end

---@return string
local function location()
    return "[%l:%c]"
end

---@return string
local function git_diff()
    return "%{get(b:,'gitsigns_status','')}"
end

StatusLine = {}

---@return string
function StatusLine.build_statusline()
    return table.concat({
        "%#LineNr#",
        filename(),
        "%r%m",
        "  ",
        git_diff(),
        "%=",
        lsp(),
        "  ",
        location(),
    })
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("StatusLine", {}),
    callback = function()
        vim.opt.statusline = "%!v:lua.StatusLine.build_statusline()"
    end,
})
