local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.enable_kitty_graphics = true
-- Font
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono",
	"Symbols Nerd Font Mono",
})
config.font_size = 13.0

--adding powershell menu
config.launch_menu = {
	{
		label = "PowerShell Core",
		args = { "pwsh.exe", "-NoLogo" },
	},
	{
		label = "Windows PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	},
}
-- Color
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.98
config.text_background_opacity = 1.0
config.background = {
	{
		source = {
			File = "C:/Users/gupta/Videos/2968617.jpg",
		},
		width = "100%",
		height = "100%",
		opacity = 0.99,
		hsb = {
			brightness = 0.11,
			saturation = 0.999,
		},
	},
}
--Window
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

-- GPU
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 1
--  PANES (add this part)
config.keys = {
	-- Split horizontally
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Split vertically
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Navigate panes
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	-- Close pane
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "Backspace",
		mods = "CTRL",
		action = wezterm.action.SendString("\x17"),
	},
}
-- Default directory to open in terminal
config.default_cwd = "C:/Users/gupta"

return config
