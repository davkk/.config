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

config.color_scheme = "rose-pine-moon"
config.colors = { background = "black" }

config.audible_bell = "Disabled"

config.font = wezterm.font_with_fallback { "Input Mono", "nonicons" }
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.underline_thickness = "0.07cell"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 100

config.disable_default_key_bindings = true
config.keys = {
    { key = "P", mods = "CTRL", action = wezterm.action.ActivateCommandPalette },
    { key = "V", mods = "CTRL", action = wezterm.action.PasteFrom "Clipboard" },
    { key = "C", mods = "CTRL", action = wezterm.action.CopyTo "Clipboard" },
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
}

return config
