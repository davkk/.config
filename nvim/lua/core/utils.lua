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

---@param fn function
---@param delay number
---@return function
function M.debounce(fn, delay)
    local timer = nil
    return function(...)
        if timer then
            vim.fn.timer_stop(timer)
        end
        local args = { ... }
        timer = vim.fn.timer_start(delay, function()
            fn(unpack(args)) ---@diagnostic disable-line: deprecated
        end)
    end
end

---@generic T
---@param tbl T
---@return T
function M.tbl_copy(tbl)
    if not tbl then
        return tbl
    end
    local new = {}
    for idx, value in ipairs(tbl) do
        new[idx] = value
    end
    return new
end

---@generic T
---@param original T[]
---@param value T
---@return T | nil
function M.append(original, value)
    if not original then
        return nil
    end
    local new = M.tbl_copy(original)
    if new then
        table.insert(new, value)
    end
    return new
end

return M
