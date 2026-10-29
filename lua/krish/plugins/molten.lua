return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",

		config = function()
			vim.g.molten_image_provider = "wezterm"
		end,
	},
}
