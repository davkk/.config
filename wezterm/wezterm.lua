local wezterm = require("wezterm")
local color_scheme = "rose-pine-moon"
local colors = wezterm.color.get_builtin_schemes()[color_scheme]

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { "zsh", "-i" }
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

config.color_scheme = color_scheme
config.colors = {
    background = "black",
    selection_fg = "black",
    selection_bg = colors.ansi[4],
    tab_bar = {
        background = "black",
        active_tab = {
            bg_color = "black",
            fg_color = colors.ansi[5],
        },
        inactive_tab = {
            bg_color = "black",
            fg_color = colors.ansi[5],
        },
    },
}

config.font = wezterm.font_with_fallback({ "Input Mono", "nonicons" })
config.warn_about_missing_glyphs = false
config.underline_thickness = 2

config.debug_key_events = true
config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    { key = "f", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "f", mods = "CTRL" }), },
    { key = "p", mods = "CTRL|SHIFT",  action = wezterm.action.ActivateCommandPalette },

    { key = "[", mods = "LEADER",      action = wezterm.action.ActivateCopyMode },

    { key = "=", mods = "CTRL",        action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL",        action = wezterm.action.DecreaseFontSize },

    { key = "s", mods = "LEADER",      action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" } },

    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action_callback(function(window)
            window:mux_window():spawn_tab { cwd = wezterm.home_dir }
        end)
    },
    { key = "x",          mods = "LEADER",       action = wezterm.action.CloseCurrentTab { confirm = true }, },

    { key = "LeftArrow",  mods = "SHIFT",        action = wezterm.action.ActivateTabRelative(-1) },
    { key = "RightArrow", mods = "SHIFT",        action = wezterm.action.ActivateTabRelative(1) },
    { key = "LeftArrow",  mods = "LEADER|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
    { key = "RightArrow", mods = "LEADER|SHIFT", action = wezterm.action.MoveTabRelative(1) },

    {
        key = "C",
        mods = "LEADER",
        action = wezterm.action.PromptInputLine {
            description = "Create new workspace",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        wezterm.action.SwitchToWorkspace {
                            name = line,
                            spawn = { cwd = wezterm.home_dir }
                        },
                        pane
                    )
                end
            end),
        },
    },

    {
        key = ",",
        mods = "LEADER",
        action = wezterm.action.PromptInputLine {
            description = "Change tab name",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        key = "<",
        mods = "LEADER|SHIFT",
        action = wezterm.action.PromptInputLine {
            description = "Change workspace name",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    local active_workspace = wezterm.mux.get_active_workspace()
                    wezterm.mux.rename_workspace(active_workspace, line)
                end
            end),
        },
    },
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i - 1),
    })
end

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 100

wezterm.on("update-status", function(window)
    local workspace = window:active_workspace()
    window:set_left_status(wezterm.format({
        { Foreground = { AnsiColor = "Blue" } },
        { Text = string.format("[%s] ", workspace) },
    }))
end)

local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab)
    return {
        { Text = " " },
        { Text = string.format("%d:", tab.tab_index + 1) },
        { Text = tab_title(tab) },
        { Text = tab.active_pane.is_zoomed and "+" or "" },
        { Text = tab.is_active and "*" or "" },
        { Text = " " },
    }
end)

return config
