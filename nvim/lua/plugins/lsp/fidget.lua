return {
    "j-hui/fidget.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        progress = {
            display = {
                done_ttl = 1,
                done_icon = "",
                progress_style = "ModeMsg",
            },
        },
        notification = {
            window = {
                normal_hl = "FloatBorder",
                border = "solid",
            },
        }
    },
}
