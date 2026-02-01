vim.keymap.set("i", "<C-q>", "<Plug>(quickfill-accept)")
vim.keymap.set("i", "<C-S-q>", "<Plug>(quickfill-accept-replace)")
vim.keymap.set("i", "<C-l>", "<Plug>(quickfill-accept-word)")
vim.keymap.set("i", "<C-space>", "<Plug>(quickfill-trigger)")

---@type quickfill.Config
vim.g.quickfill = {
    n_prefix = 8,
    n_suffix = 8,
    n_predict = 16,
    max_extra_chunks = 4,
    max_lsp_completion_items = 10,
    lsp_signature_help = true,
    stop_on_trigger_char = false,
}
