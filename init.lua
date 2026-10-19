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
