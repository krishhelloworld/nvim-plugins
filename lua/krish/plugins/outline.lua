return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen", "OutlineClose" },

	keys = {
		{
			"<leader>o",
			"<cmd>Outline<CR>",
			desc = "Toggle Code/Markdown Outline",
		},
	},

	opts = {
		outline_window = {
			position = "right",
			width = 35,
			auto_close = false,
		},

		preview_window = {
			live = true,
		},

		providers = {
			priority = {
				"markdown_extend",
				"lsp",
				"markdown",
				"norg",
				"man",
			},
		},

		symbols = {
			icons = {
				Module = { icon = "󰫢", hl = "DiagnosticError" },
				Class = { icon = "◆", hl = "DiagnosticInfo" },
				Function = { icon = "󰊕", hl = "DiagnosticHint" },
				Method = { icon = "◈", hl = "DiagnosticInfo" },
				Constant = { icon = "✦", hl = "DiagnosticWarn" },
				Property = { icon = "◇", hl = "Special" },
				String = { icon = "❯", hl = "DiagnosticInfo" },
				Event = { icon = "☐", hl = "DiagnosticWarn" },
				EnumMember = { icon = "☑", hl = "DiagnosticOk" },
			},
		},

		keymaps = {
			show_help = "?",
			close = { "<Esc>", "q" },
			goto_location = "<Cr>",
			peek_location = "p",
		},
	},

	config = function(_, opts)
		require("outline").setup(opts)

		vim.api.nvim_set_hl(0, "OutlineH1", {
			fg = "#E06C75",
			bold = true,
		})
		vim.api.nvim_set_hl(0, "OutlineH2", {
			fg = "#E5C07B",
			bold = true,
		})
		vim.api.nvim_set_hl(0, "OutlineH3", {
			fg = "#98C379",
			italic = true,
		})
		vim.api.nvim_set_hl(0, "OutlineH4", {
			fg = "#61AFEF",
		})
		vim.api.nvim_set_hl(0, "OutlineH5", {
			fg = "#C678DD",
		})
		vim.api.nvim_set_hl(0, "OutlineH6", {
			fg = "#56B6C2",
			italic = true,
		})
	end,
}
