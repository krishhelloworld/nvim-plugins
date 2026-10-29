return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",

	opts = {
		default = {
			dir_path = "assets",
			relative_to_current_file = true,
			prompt_for_file_name = true,
		},

		filetypes = {
			markdown = {
				template = "![$CURSOR]($FILE_PATH)",
				download_images = false,
			},
		},
	},

	keys = {
		{
			"<leader>v",
			"<cmd>PasteImage<cr>",
			desc = "Paste Image",
		},
	},
}
