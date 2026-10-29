--i want code for the copy paste register , to know all the copied and to selete one and paste it .

vim.env.CC = "gcc"

require("krish.core")
require("krish.lazy")
vim.cmd.colorscheme("tokyonight")
vim.g.python3_host_prog = "C:\\Users\\gupta\\AppData\\Local\\Python\\bin\\python.exe"
vim.opt.autochdir = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true })

vim.keymap.set("n", "<A-x>", function()
	local current = vim.api.nvim_get_current_buf()
	vim.cmd("bnext")
	vim.cmd("bdelete " .. current)
end, { desc = "Delete buffer and switch to next" })
vim.keymap.set("n", "<M-9>", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<M-0>", ":bp<CR>", { desc = "Previous buffer" }) -- Don't show mode twice
vim.keymap.set("n", "g==G", function()
	require("conform").format({
		async = false,
		timeout_ms = 2000,
	})
end, { desc = "Format with Conform" })
-- vim.keymap.set({ "n", "t" }, "<C-\\>", toggle_terminal, {
-- 	desc = "Toggle Terminal in Current Directory",
-- })
vim.api.nvim_set_hl(0, "Folded", {
	bg = "NONE",
})
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", {
			bg = "#000000",
			fg = "#cba6f7",
			bold = true,
		})
	end,
})
local terminal_buf = nil
local terminal_win = nil

function toggle_terminal()
	if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
		vim.api.nvim_win_close(terminal_win, true)
		terminal_win = nil
		return
	end

	if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
		vim.cmd("botright split")
		vim.api.nvim_win_set_buf(0, terminal_buf)
	else
		vim.cmd("botright split | terminal")
		terminal_buf = vim.api.nvim_get_current_buf()
	end

	terminal_win = vim.api.nvim_get_current_win()
	vim.cmd("startinsert")
end

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function(args)
-- 		vim.keymap.set("n", "gd", function()
-- 			local line = vim.api.nvim_get_current_line()
-- 			local col = vim.api.nvim_win_get_cursor(0)[2] + 1

-- 			-- Find Markdown links: [text](file.md)
-- 			for start_pos, path in line:gmatch("()%]%(([^)#]+)") do
-- 				local link_start = start_pos - #path - 1
-- 				local link_end = start_pos + #path + 1

-- 				if col >= link_start and col <= link_end then
-- 					local target = vim.fs.normalize(vim.fs.joinpath(vim.fn.expand("%:p:h"), path))

-- 					vim.cmd("edit " .. vim.fn.fnameescape(target))
-- 					return
-- 				end
-- 			end

-- 			vim.lsp.buf.definition()
-- 		end, {
-- 			buffer = args.buf,
-- 			desc = "Open Markdown link",
-- 		})
-- 	end,
-- })

local function set_wezterm_markdown_background(enabled)
	local value = enabled and "1" or "0"
	local encoded = vim.base64.encode(value)
	local sequence = "\027]1337;SetUserVar=NVIM_MARKDOWN=" .. encoded .. "\007"

	-- This sequence must reach WezTerm's terminal parser.
	-- Do not use vim.notify() for this.
	io.stdout:write(sequence)
	io.stdout:flush()
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		set_wezterm_markdown_background(true)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		if args.match ~= "markdown" then
			set_wezterm_markdown_background(false)
		end
	end,
})
--
-- Customize comment colors only
vim.api.nvim_set_hl(0, "Comment", {
	fg = "#bababa",
	italic = true,
})

vim.api.nvim_set_hl(0, "@comment", {
	fg = "#bababa",
	italic = true,
})
