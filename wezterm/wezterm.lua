local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- OPTIONS
config.term = "wezterm"

config.check_for_updates = false

config.audible_bell = "Disabled"
config.cursor_blink_rate = 0
config.adjust_window_size_when_changing_font_size = false

-- WINDOW
config.initial_cols = 120
config.initial_rows = 40
config.max_fps = 144

config.enable_scroll_bar = false
config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- COLORS
local palette = {
    base = "#1a1821",
    overlay = "#2f2b3b",
    muted = "#645c70",
    subtle = "#8d849a",
    text = "#dad6e9",
    love = "#f56389",
    gold = "#ffb083",
    rose = "#edb2b5",
    pine = "#628079",
    foam = "#b7d7d5",
    iris = "#d2b1d6",
    highlight_low = "#23222b",
    highlight_med = "#403e4e",
    highlight_high = "#545161",
}

config.colors = {
    foreground = palette.text,
    -- background = palette.base,
    cursor_fg = palette.base,
    cursor_border = palette.text,
    cursor_bg = palette.text,
    selection_bg = palette.highlight_med,

    ansi = {
        palette.overlay,
        palette.love,
        palette.pine,
        palette.gold,
        palette.foam,
        palette.iris,
        palette.rose,
        palette.text,
    },

    brights = {
        palette.muted,
        palette.love,
        palette.pine,
        palette.gold,
        palette.foam,
        palette.iris,
        palette.rose,
        palette.text,
    },

    tab_bar = {
        background = "none",

        active_tab = {
            bg_color = "none",
            fg_color = palette.text,
            intensity = "Bold",
        },

        inactive_tab = {
            bg_color = "none",
            fg_color = palette.highlight_high,
        },

        inactive_tab_hover = {
            bg_color = "none",
            fg_color = palette.highlight_high,
        },

        new_tab = {
            bg_color = "none",
            fg_color = palette.overlay,
        },

        new_tab_hover = {
            bg_color = "none",
            fg_color = palette.overlay,
        },
    }
}

-- FONT
config.font = wezterm.font_with_fallback({ "Input Mono", "nonicons" })
config.use_cap_height_to_scale_fallback_fonts = true
config.cell_width = 1
config.underline_thickness = 4
config.font_size = 21
config.warn_about_missing_glyphs = false -- life saver


-- LINKS
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
    regex = "\\b\\w+://(?:[\\w.-]+):\\d+\\S*\\b",
    format = "$0",
})
table.insert(config.hyperlink_rules, {
    regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
    format = "$0",
})

-- KEYBINDINGS
config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- Send "CTRL-F" to the terminal when pressing CTRL-F + CTRL-F
    {
        key = "f",
        mods = "LEADER|CTRL",
        action = wezterm.action.SendKey({ key = "b", mods = "CTRL" }),
    },

    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "x",
        mods = "LEADER",
        action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
        key = "n",
        mods = "LEADER",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "p",
        mods = "LEADER",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "[",
        mods = "LEADER",
        action = wezterm.action.ActivateCopyMode,
    },

    {
        key = "Enter",
        mods = "ALT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "F11",
        action = wezterm.action.ToggleFullScreen,
    },

    {
        key = "f",
        mods = "LEADER",
        action = wezterm.action.SpawnCommandInNewTab({
            args = {
                string.format("%s/.config/.scripts/wezterm-tabizer", wezterm.home_dir)
            },
        }),
    },
    {
        key = ".",
        mods = "LEADER",
        action = wezterm.action.SpawnCommandInNewTab({
            args = {
                string.format("%s/.config/.scripts/wezterm-tabizer", wezterm.home_dir),
                string.format("%s/.config", wezterm.home_dir),
            },
        }),
    },
}

for i = 1, 5 do
    -- CTRL + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "CTRL",
        action = wezterm.action.ActivateTab(i - 1),
    })
end
for i = 1, 9 do
    -- F1 through F9 to activate that tab
    table.insert(config.keys, {
        key = "F" .. tostring(i),
        action = wezterm.action.ActivateTab(i - 1),
    })
end

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


-- TABS
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 100

local tab_title = function(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

wezterm.on(
    "format-tab-title",
    function(tab)
        local title = tab_title(tab)
        return {
            { Text = string.format("%d:[%s]  ", tab.tab_index + 1, title) },
        }
    end
)

return config
