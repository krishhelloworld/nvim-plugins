return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		opts = {
			-- Keep your existing input behavior
			styles = {
				input = {
					keys = {
						n_esc = {
							"<C-c>",
							{ "cmp_close", "cancel" },
							mode = "n",
							expr = true,
						},
						i_esc = {
							"<C-c>",
							{ "cmp_close", "stopinsert" },
							mode = "i",
							expr = true,
						},
					},
				},
				snacks_image = {
					border = "none",
					focusable = false,
					backdrop = false,
					row = -5,
					col = -2,
					-- row = -4,
					-- col = 45,
					wo = {
						winhighlight = "Normal:Normal,NormalFloat:Normal",
					},
				},
			},

			input = {
				enabled = true,
			},

			quickfile = {
				enabled = true,
				exclude = { "latex" },
			},

			-- Picker configuration
			picker = {
				enabled = true,

				matchers = {
					frecency = true,
					cwd_bonus = false,
				},

				exclude = {
					".git",
					"node_modules",
					"dist",
					"build",
				},

				formatters = {
					file = {
						filename_first = true,
						filename_only = false,
						icon_width = 2,
					},
				},

				-- Preserve your original default
				layout = {
					preset = "telescope",
					cycle = false,
				},

				layouts = {
					-- Keep your select layout
					select = {
						preview = false,
						layout = {
							backdrop = false,
							width = 0.6,
							min_width = 80,
							height = 0.4,
							min_height = 10,
							box = "vertical",
							border = "rounded",
							title = "{title}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{
								win = "preview",
								title = "{preview}",
								width = 0.6,
								height = 0.4,
								border = "top",
							},
						},
					},

					-- Your original Telescope-style layout
					telescope = {
						reverse = true,
						layout = {
							box = "horizontal",
							backdrop = false,
							width = 0.8,
							height = 0.9,
							border = "none",
							{
								box = "vertical",
								{
									win = "list",
									title = " Results ",
									title_pos = "center",
									border = "rounded",
								},
								{
									win = "input",
									height = 1,
									border = "rounded",
									title = "{title} {live} {flags}",
									title_pos = "center",
								},
							},
							{
								win = "preview",
								title = "{preview:Preview}",
								width = 0.50,
								border = "rounded",
								title_pos = "center",
							},
						},
					},

					-- Added from the other configuration
					ivy = {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0,
							height = 0.4,
							position = "bottom",
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{
									win = "preview",
									title = "{preview}",
									width = 0.5,
									border = "left",
								},
							},
						},
					},

					-- Added: larger bottom picker with preview
					ivy_split = {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0,
							height = 0.6,
							position = "bottom",
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{
									win = "preview",
									title = "{preview}",
									width = 0.6,
									border = "left",
								},
							},
						},
					},

					-- Added: vertical picker
					vertical = {
						layout = {
							backdrop = false,
							width = 0.8,
							min_width = 80,
							height = 0.8,
							min_height = 30,
							box = "vertical",
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{
								win = "preview",
								title = "{preview}",
								height = 0.4,
								border = "top",
							},
						},
					},
				},

				-- Added picker interaction settings
				win = {
					preview = {
						wo = {
							foldenable = false,
						},
					},

					input = {
						keys = {
							["J"] = {
								"preview_scroll_down",
								mode = { "i", "n" },
							},
							["K"] = {
								"preview_scroll_up",
								mode = { "i", "n" },
							},
							["H"] = {
								"preview_scroll_left",
								mode = { "i", "n" },
							},
							["L"] = {
								"preview_scroll_right",
								mode = { "i", "n" },
							},
						},
					},
				},

				matcher = {
					frecency = true,
				},
			},

			-- Preserve your image configuration

			image = {
				enabled = true,

				doc = {
					enabled = true,
					inline = false,
					float = true,
					max_width = 30,
					max_height = 30,
				},
				convert = {
					notify = true,
					magick = {
						default = { "{src}[0]", "-auto-orient", "-scale", "1920x1080>" },
					},
				},
				img_dirs = {
					"img",
					"images",
					"assets",
					"static",
					"public",
					"media",
					"attachments",
					"Archives/All-Vault-Images",
					"~/Library",
					"~/Downloads",
				},
			},
			-- Added from the other configuration
			notifier = {
				enabled = true,
				top_down = false,
			},

			-- Added LazyGit window settings
			lazygit = {
				theme = {
					selectedLineBgColor = { bg = "CursorLine" },
				},

				win = {
					width = 0,
					height = 0,
				},
			},
		},
		config = function(_, opts)
			Snacks = require("snacks")
			Snacks.setup(opts)

			local image = require("snacks.image")
			local original_langs = image.langs
			-- Force a full repaint after leaving/closing anything that may hold an image
			local image_exts = { "png", "jpg", "jpeg", "gif", "webp", "bmp", "svg", "pdf", "avif", "heic" }

			local function is_image(name)
				local ext = name:match("%.(%w+)$")
				return ext and vim.tbl_contains(image_exts, ext:lower())
			end

			local redraw_timer = vim.uv.new_timer()
			local function clear_image_artifacts()
				redraw_timer:stop()
				redraw_timer:start(
					30, -- give snacks time to send the "delete image" escape code first
					0,
					vim.schedule_wrap(function()
						vim.cmd("redraw!")
					end)
				)
			end

			vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave", "BufHidden" }, {
				group = vim.api.nvim_create_augroup("SnacksImageCleanup", { clear = true }),
				callback = function(ev)
					if is_image(vim.api.nvim_buf_get_name(ev.buf)) then
						clear_image_artifacts()
					end
				end,
			})

			-- Picker preview windows and image float windows closing
			vim.api.nvim_create_autocmd({ "WinClosed", "WinLeave" }, {
				group = "SnacksImageCleanup",
				callback = function(ev)
					local ok, buf = pcall(vim.api.nvim_win_get_buf, tonumber(ev.match) or 0)
					if ok and is_image(vim.api.nvim_buf_get_name(buf)) then
						clear_image_artifacts()
					end
				end,
			})
			image.langs = function()
				local languages = {}

				for _, path in ipairs(vim.api.nvim_get_runtime_file("queries/*/images.scm", true)) do
					local normalized = path:gsub("\\", "/")
					local lang = normalized:match("queries/(.-)/images%.scm")

					if lang then
						languages[#languages + 1] = lang
					end
				end

				return languages
			end
		end,
		-- Preserve existing keymaps and add new ones separately
		keys = {
			-- Your existing keymaps
			{
				"<leader>lg",
				function()
					require("snacks").lazygit()
				end,
				desc = "Lazygit",
			},

			{
				"<leader>gl",
				function()
					require("snacks").lazygit.log()
				end,
				desc = "Lazygit Logs",
			},

			{
				"<leader>rN",
				function()
					require("snacks").rename.rename_file()
				end,
				desc = "Fast Rename Current File",
			},

			{
				"<leader>dB",
				function()
					require("snacks").bufdelete()
				end,
				desc = "Delete or Close Buffer (Confirm)",
			},

			{
				"<leader>pws",
				function()
					require("snacks").picker.grep_word()
				end,
				desc = "Search Visual Selection or Word",
				mode = { "n", "x" },
			},

			{
				"<leader>pk",
				function()
					require("snacks").picker.keymaps({
						layout = "ivy",
					})
				end,
				desc = "Search Keymaps (Snacks Picker)",
			},

			{
				"<leader>gbr",
				function()
					require("snacks").picker.git_branches({
						layout = "select",
					})
				end,
				desc = "Pick and Switch Git Branches",
			},

			{
				"<leader>th",
				function()
					require("snacks").picker.colorschemes({
						layout = "ivy",
					})
				end,
				desc = "Pick Color Schemes",
			},

			{
				"<leader>vh",
				function()
					require("snacks").picker.help()
				end,
				desc = "Help Pages",
			},

			-- Added: Git history, without replacing <leader>gl
			{
				"<leader>gL",
				function()
					require("snacks").picker.git_log({
						layout = "vertical",
					})
				end,
				desc = "Git Log Picker",
			},

			-- Added: smart file picker, using a new shortcut
			{
				"<leader>sf",
				function()
					require("snacks").picker.smart({})
				end,
				desc = "Smart File Picker",
			},

			-- Added: grep picker with a custom exclusion
			{
				"<leader>sg",
				function()
					require("snacks").picker.grep({
						exclude = { "dictionaries/words.txt" },
					})
				end,
				desc = "Grep",
			},

			-- Added: buffer navigation without replacing <S-h>
			{
				"<leader>bb",
				function()
					require("snacks").picker.buffers({
						on_show = function()
							vim.cmd.stopinsert()
						end,
						finder = "buffers",
						format = "buffer",
						hidden = false,
						unloaded = true,
						current = true,
						sort_lastused = true,
						win = {
							input = {
								keys = {
									["d"] = "bufdelete",
								},
							},
							list = {
								keys = {
									["d"] = "bufdelete",
								},
							},
						},
					})
				end,
				desc = "Browse Buffers",
			},

			-- Added: task search
			{
				"<leader>tt",
				function()
					require("snacks").picker.grep({
						prompt = " ",
						search = "^\\s*- \\[ \\]",
						regex = true,
						live = false,
						dirs = { vim.fn.getcwd() },
						glob = "*.md",
						args = { "--no-ignore" },
						finder = "grep",
						format = "file",
						supports_live = false,
						show_empty = true,
						layout = "ivy_split",
					})
				end,
				desc = "Search Incomplete Markdown Tasks",
			},

			{
				"<leader>tc",
				function()
					require("snacks").picker.grep({
						prompt = " ",
						search = "^\\s*- \\[[xX]\\](?: `done:)?",
						regex = true,
						live = false,
						dirs = { vim.fn.getcwd() },
						glob = "*.md",
						args = { "--no-ignore" },
						finder = "grep",
						format = "file",
						supports_live = false,
						show_empty = true,
						layout = "ivy",
						on_show = function()
							vim.cmd.stopinsert()
						end,
					})
				end,
				desc = "Search Completed Markdown Tasks",
			},

			-- Added: search video-idea tags
			{
				"<leader>ti",
				function()
					require("snacks").picker.grep({
						prompt = " ",
						search = "vid-id$",
						regex = true,
						live = false,
						dirs = { vim.fn.getcwd() },
						args = { "--no-ignore" },
						finder = "grep",
						format = "file",
						supports_live = false,
						show_empty = true,
						layout = "ivy",
					})
				end,
				desc = "Search Video Ideas",
			},
		},
	},

	-- Preserve your optional TODO Comments integration
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		optional = true,

		keys = {
			{
				"<leader>pt",
				function()
					require("snacks").picker.todo_comments()
				end,
				desc = "Search TODO Comments",
			},

			{
				"<leader>pT",
				function()
					require("snacks").picker.todo_comments({
						keywords = {
							"TODO",
							"FORGETNOT",
							"FIXME",
						},
					})
				end,
				desc = "Search Selected TODO Keywords",
			},
		},
	},
}
