local M = {}

local utils = require "core.utils"

M.item_kind_map = {
    [1] = "Text",
    [2] = "Method",
    [3] = "Function",
    [4] = "Constructor",
    [5] = "Field",
    [6] = "Variable",
    [7] = "Class",
    [8] = "Interface",
    [9] = "Module",
    [10] = "Property",
    [11] = "Unit",
    [12] = "Value",
    [13] = "Enum",
    [14] = "Keyword",
    [15] = "Snippet",
    [16] = "Color",
    [17] = "File",
    [18] = "Reference",
    [19] = "Folder",
    [20] = "EnumMember",
    [21] = "Constant",
    [22] = "Struct",
    [23] = "Event",
    [24] = "Operator",
    [25] = "TypeParameter",
}

---@param item lsp.CompletionItem
---@return table
function M.convert_completion_item(item)
    local limit = vim.o.columns * 0.4
    local label = item.label
    if #label > limit then
        label = label:sub(1, limit)
        local last_comma = label:match ".*(),"
        if last_comma then
            label = label:sub(1, last_comma) .. " …)"
        end
    end
    return {
        abbr = label,
        kind = item.kind and M.item_kind_map[item.kind] or 1,
        menu = item.detail and utils.shorten_path(item.detail, 15) or "",
    }
end

return M
