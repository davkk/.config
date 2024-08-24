local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { "zsh", "-l" }
config.max_fps = 144

config.adjust_window_size_when_changing_font_size = false

config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.font = wezterm.font_with_fallback({ "Input Mono", "nonicons" })
config.warn_about_missing_glyphs = false
config.underline_thickness = 2

config.keys = {
    {
        key = "Enter",
        mods = "ALT",
        action = wezterm.action.DisableDefaultAssignment,
    },
}

config.enable_tab_bar = false

return config
