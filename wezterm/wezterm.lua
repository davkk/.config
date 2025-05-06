local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

-- startup
config.default_prog = { "/usr/bin/env", "zsh", "-l" }

-- window
config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_close_confirmation = "AlwaysPrompt"
config.skip_close_confirmation_for_processes_named = {}
config.audible_bell = "Disabled"

local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[1]
config.front_end = "WebGpu"
config.max_fps = 144

-- colors
config.color_scheme = "neovim"

-- fonts
config.font = wezterm.font_with_fallback { "Input Mono" }
config.freetype_load_target = "Light"
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.underline_thickness = "0.08cell"

-- tabs
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 100

wezterm.on("format-tab-title", function(tab)
    local tab_title = tab.tab_title
    local pane_title = tab.active_pane.title
    return {
        { Text = " " },
        { Text = string.format("%d:", tab.tab_index + 1) },
        { Text = "[" },
        { Text = (tab_title and #tab_title > 0) and tab_title or pane_title },
        { Text = "]" },
        { Text = " " },
    }
end)

-- key bindings
config.keys = {
    { key = "UpArrow",   mods = "SHIFT", action = action.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = action.ScrollToPrompt(1) },
}

return config
