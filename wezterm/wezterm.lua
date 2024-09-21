local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { "/usr/bin/env", "zsh", "-l" }

config.window_decorations = "RESIZE"
config.window_padding = { left = 3, right = 3, top = 3, bottom = 3 }
config.enable_scroll_bar = false

config.max_fps = 144
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

local color_scheme = "rose-pine-moon"
local colors = wezterm.get_builtin_color_schemes()[color_scheme]
local tab_color = { bg_color = "black", fg_color = colors.brights[1] }
config.color_scheme = color_scheme
config.colors = {
    background = "black",
    selection_bg = colors.ansi[4],
    selection_fg = "black",
    tab_bar = {
        background = "black",
        active_tab = tab_color,
        inactive_tab = tab_color,
        inactive_tab_hover = tab_color,
    },
}

config.audible_bell = "Disabled"
config.window_close_confirmation = "AlwaysPrompt"
config.skip_close_confirmation_for_processes_named = {}

config.font = wezterm.font_with_fallback { "Input Mono", "nonicons" }
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.underline_thickness = "0.07cell"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 100

wezterm.on("format-tab-title", function(tab)
    local tab_title = tab.tab_title
    local pane_title = tab.active_pane.title
    return {
        { Text = string.format("%d:", tab.tab_index + 1) },
        { Text = "[" },
        { Text = (tab_title and #tab_title > 0) and tab_title or pane_title },
        { Text = "]" },
        { Text = tab.is_active and "*" or "" },
        { Text = " " },
    }
end)

return config
