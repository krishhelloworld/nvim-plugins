return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local conform = require("conform")

		conform.setup({

			-- =========================================
			-- CUSTOM FORMATTERS
			-- =========================================
			formatters = {

				-- Markdown TOC
				["markdown-toc"] = {
					command = "markdown-toc",
					args = { "-i" },
					stdin = false,
				},

				-- Markdown lint
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))

						return #diag > 0
					end,
				},

				-- =========================================
				-- AStyle - C / C++
				-- =========================================
				astyle = {
					command = "C:/Users/gupta/Downloads/astyle-3.6.18-x64/astyle-3.6.18-x64/astyle.exe",

					args = {
						"--style=java",
						"--indent=spaces=4",
						"--pad-oper",
						"--pad-header",
						"--unpad-paren",
						"--align-pointer=name",
						"--align-reference=name",

						-- Keep one-line blocks/statements
						"--keep-one-line-blocks",
						"--keep-one-line-statements",

						"--max-code-length=120",
					},

					stdin = true,
				},
			},

			-- =========================================
			-- FORMATTERS BY FILETYPE
			-- =========================================
			formatters_by_ft = {

				-- JavaScript
				javascript = { "prettier" },
				javascriptreact = { "prettier" },

				-- TypeScript
				typescript = { "prettier" },
				typescriptreact = { "prettier" },

				-- Web
				css = { "biome" },
				json = { "prettier" },
				html = { "prettier" },
				svelte = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },

				-- Lua
				lua = { "stylua" },

				-- =========================================
				-- C / C++
				-- =========================================
				c = { "astyle" },
				cpp = { "astyle" },

				-- Markdown
				markdown = { "mdformat", "markdown-toc" },

				--Python
				python = { "ruff_format" },
			},

			-- =========================================
			-- FORMAT ON SAVE
			-- =========================================
			format_on_save = {
				lsp_fallback = false,
				async = false,
				timeout_ms = 5000,
			},
		})

		-- =========================================
		-- BIOME
		-- =========================================
		conform.formatters.biome = {
			command = "biome",
			args = {
				"format",
				"--stdin-file-path",
				"$FILENAME",
				"--write",
				"--formatter-format-with-errors",
			},
			stdin = true,
		}

		-- =========================================
		-- PRETTIER
		-- =========================================
		conform.formatters.prettier = {
			command = "prettier",
			args = {
				"--stdin-filepath",
				"$FILENAME",
			},
			stdin = true,
		}

		-- =========================================
		-- FORMAT KEYMAP
		-- =========================================
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 5000,
			})
		end, {
			desc = "Format file or selection",
		})
	end,
}
