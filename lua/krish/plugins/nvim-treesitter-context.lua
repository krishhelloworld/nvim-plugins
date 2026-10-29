return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "LazyFile",
	opts = {
		mode = "cursor",
		max_lines = 3,
	},
	keys = {
		{
			"<leader>ut",
			function()
				local tsc = require("treesitter-context")
				tsc.toggle()
				vim.notify("Toggled Treesitter Context")
			end,
			desc = "Toggle Treesitter Context",
		},
	},
}
