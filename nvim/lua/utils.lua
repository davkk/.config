local M = {}

---@param path string
---@param max_len number
---@return string
function M.shorten_path(path, max_len)
    local len = #path
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
        local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
        segments[idx] = shortened
        len = len - (#segment - #shortened)
    end

    return table.concat(segments, sep)
end

return M
