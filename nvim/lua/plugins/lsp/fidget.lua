return {
    "j-hui/fidget.nvim",
    event = { "BufReadPost", "BufNewFile" },
    branch = "legacy",
    opts = {
        text = {
            spinner = "line",
            done = "",
        },
        timer = {
            spinner_rate = 200,      -- frame rate of spinner animation, in ms
            fidget_decay = 1000,     -- how long to keep around empty fidget, in ms
            task_decay = 700,        -- how long to keep around completed task, in ms
        },
        window = {
            relative = "editor",
            blend = 0,
            zindex = 100,
        },
    },
}
