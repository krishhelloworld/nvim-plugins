return {
	"nvim-lua/plenary.nvim",

	{
		"christoomey/vim-tmux-navigator",
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
	},

	-- fixes the well know nvim bug
	{
		"folke/lazydev.nvim",
		lazy = "VeryLazy",
		priority = 1000,
		opts = {
			library = {
				{
					path = "${3rd}/plenary.nvim/lua",
					words = { "plenary" },
				},
				{ path = "LazyVim" },
			},
		},
	},
}
