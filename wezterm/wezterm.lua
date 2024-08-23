local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.check_for_updates = false

config.audible_bell = "Disabled"
config.cursor_blink_rate = 0
config.adjust_window_size_when_changing_font_size = false

config.initial_cols = 120
config.initial_rows = 40
config.max_fps = 144

config.enable_scroll_bar = false
-- config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.color_scheme = "rose-pine-moon"
config.colors = {
    background = "#000000",
    cursor_bg = "#52ad70",
    cursor_fg = "black",
}

config.font = wezterm.font_with_fallback({ "Input Mono", "nonicons" })
config.use_cap_height_to_scale_fallback_fonts = false
config.underline_thickness = 2
config.font_size = 21
config.warn_about_missing_glyphs = false -- life saver

config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
    regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b",
    format = "$0",
})
table.insert(config.hyperlink_rules, {
    regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
    format = "$0",
})

config.keys = {
    {
        key = "Enter",
        mods = "ALT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "F11",
        action = wezterm.action.ToggleFullScreen,
    },
}

config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
    },
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 100

return config
