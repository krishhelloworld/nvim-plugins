return {
"stevearc/conform.nvim",
event = { "BufReadPre", "BufNewFile" },

config = function()
    local conform = require("conform")

    conform.setup({
        -- Custom formatters
        formatters = {
            ["markdown-toc"] = {
                command = "markdown-toc",
                args = { "-i" },
                stdin = false,
            },

            ["markdownlint-cli2"] = {
                condition = function(_, ctx)
                    local diag = vim.tbl_filter(function(d)
                        return d.source == "markdownlint"
                    end, vim.diagnostic.get(ctx.buf))

                    return #diag > 0
                end,
            },
        },

        -- Formatters by filetype
        formatters_by_ft = {
            -- JavaScript / TypeScript
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },

            -- Web
            css = { "biome" },
            json = { "biome" },
            html = { "prettier" },
            svelte = { "prettier" },
            yaml = { "prettier" },
            graphql = { "prettier" },
            liquid = { "prettier" },

            -- Lua
            lua = { "stylua" },

            -- C / C++
            c = { "astyle" },
            cpp = { "astyle" },

            -- Python
            python = { "black" },

            -- Markdown
            markdown = { "mdformat", "markdown-toc" },
        },

        -- Format automatically when saving
        format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 2000,
        },
    })

    -- Biome
    conform.formatters.biome = {
        command = "biome",
        args = {
            "format",
            "--stdin-file-path",
            "$FILENAME",
        },
        stdin = true,
    }

    -- Prettier
    conform.formatters.prettier = {
        command = "prettier",
        args = {
            "--stdin-filepath",
            "$FILENAME",
        },
        stdin = true,
    }

    -- AStyle for C / C++
conform.formatters.astyle = {
	command = "C:/Users/Krish Gupta/Downloads/astyle-3.6.17-x64/astyle-3.6.17-x64/astyle.exe",
	args = {
		"--style=allman",
		"--indent=spaces=4",
		"--pad-oper",
		"--pad-header",
		"--unpad-paren",
		"--align-pointer=name",
		"--align-reference=name",
		"--keep-one-line-blocks",
		"--keep-one-line-statements",
		"--max-code-length=120",
	},
	stdin = true,
}

    -- Black for Python
    conform.formatters.black = {
        command = "black",
        args = {
            "--quiet",
            "-",
        },
        stdin = true,
    }

    -- Format file or visual selection
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 2000,
        })
    end, { desc = "Format file or selection" })
end,
}
