local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- =========================================================
-- FONT
-- =========================================================

-- Change this to the EXACT font you want to use in Neovim.
config.font = wezterm.font_with_fallback {
    'JetBrains Mono'
}

config.font_size = 11.5

-- =========================================================
-- WINDOW
-- =========================================================

config.font_size = 19

config.enable_tab_bar = false

config.window_decorations = 'TITLE | RESIZE'


-- =========================================================
-- TAB BAR
-- =========================================================

-- Don't show tabs when there is only one tab
-- config.hide_tab_bar_if_only_one_tab = true

-- If you never use multiple tabs, change this to false:
-- config.enable_tab_bar = false

-- =========================================================
-- GPU / RENDERING
-- =========================================================


-- =========================================================
-- TERMINAL
-- =========================================================

config.default_cursor_style = 'SteadyBar'

config.cursor_blink_rate = 0

-- =========================================================
-- COLORS
-- =========================================================

-- =========================================================
-- BACKGROUND
-- =========================================================

return config