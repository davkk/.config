return {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                },
                checkThirdParty = false,
            },
            telemetry = { enable = false, },
        },
    },
}
