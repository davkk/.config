local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- OPTIONS
config.term = "wezterm"

config.audible_bell = "Disabled"
config.cursor_blink_rate = 0
config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing = false

-- TABS
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- WINDOW
config.initial_cols = 120
config.initial_rows = 40
config.max_fps = 144
config.cell_width = 0.9

config.window_background_opacity = 0.8
config.window_decorations = "RESIZE"
config.window_padding = {
    left = "1cell",
    right = "1cell",
    top = "0.5cell",
    bottom = "0.5cell",
}

-- COLORS
local palette = {
    base = "#1a1821",
    overlay = "#282333",
    subtle = "#5A5365",
    muted = "#707a7d",
    text = "#dad6e9",
    love = "#f56389",
    gold = "#ffb083",
    rose = "#edb2b5",
    pine = "#628079",
    foam = "#b7d7d5",
    iris = "#d7afd8",
    highlight_high = "#524f67"
}

config.colors = {
    foreground = palette.text,
    -- background = palette.base,
    cursor_fg = palette.base,
    cursor_border = palette.text,
    cursor_bg = palette.text,
    selection_bg = "#2a283e",
    selection_fg = palette.text,

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
            fg_color = palette.muted,
            intensity = "Bold",
        },

        inactive_tab_hover = {
            bg_color = "none",
            fg_color = palette.muted,
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
config.font = wezterm.font_with_fallback {
    {
        family = "iMWritingMono Nerd Font",
        stretch = "ExtraExpanded",
        harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
    },
}
config.font_size = 19
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
    -- Change the default click behavior so that it only selects
    -- text and doesn"t open hyperlinks
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor "Clipboard",
    },

    -- Bind 'Up' event of CTRL-Click to open hyperlinks
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

return config
