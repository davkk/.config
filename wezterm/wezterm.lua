local wezterm = require("wezterm")

local color_scheme = "rose-pine-moon"
local colors = wezterm.color.get_builtin_schemes()[color_scheme]

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { "zsh", "-i" }

config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_scroll_bar = false
config.max_fps = 144

config.color_scheme = color_scheme
config.colors = {
    background = "black",
    selection_bg = colors.ansi[4],
    selection_fg = "black",
    tab_bar = {
        background = "black",
        active_tab = { bg_color = "black", fg_color = colors.brights[1] },
        inactive_tab = { bg_color = "black", fg_color = colors.brights[1] },
    },
}

config.font = wezterm.font_with_fallback { "Input Mono", "nonicons" }
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false
config.underline_thickness = 2

config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    { key = "f",          mods = "LEADER|CTRL", action = wezterm.action.SendKey { key = "f", mods = "CTRL" }, },
    { key = "[",          mods = "LEADER",      action = wezterm.action.ActivateCopyMode },
    { key = "s",          mods = "LEADER",      action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" } },
    { key = "c",          mods = "LEADER",      action = wezterm.action.SpawnTab "CurrentPaneDomain" },
    { key = "x",          mods = "LEADER",      action = wezterm.action.CloseCurrentTab { confirm = true }, },
    { key = "LeftArrow",  mods = "SHIFT",       action = wezterm.action.ActivateTabRelative(-1) },
    { key = "RightArrow", mods = "SHIFT",       action = wezterm.action.ActivateTabRelative(1) },
}

wezterm.on("update-status", function(window)
    local workspace = window:active_workspace()
    window:set_left_status(wezterm.format {
        { Foreground = { Color = colors.brights[1] } },
        { Text = string.format("[%s] ", workspace) },
    })
end)

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 100

wezterm.on("format-tab-title", function(tab)
    local tab_title = tab.tab_title
    local pane_title = tab.active_pane.title
    return {
        { Text = " " },
        { Text = string.format("%d:", tab.tab_index + 1) },
        { Text = (tab_title and #tab_title > 0) and tab_title or pane_title },
        { Text = tab.is_active and "*" or "" },
        { Text = " " },
    }
end)

return config
