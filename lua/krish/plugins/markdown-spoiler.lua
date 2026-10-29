local M = {}

local ns = vim.api.nvim_create_namespace("markdown_spoiler")
local revealed = {}
local enabled = true

local function get_spoilers(buf)
	local result = {}

	for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		local start = 1

		while true do
			local a, b = line:find("%|%|.-%|%|", start)
			if not a then
				break
			end

			-- Exclude the || delimiters from the concealed text.
			table.insert(result, {
				row = row - 1,
				first = a - 1,
				last = b,
				text_first = a + 1,
				text_last = b - 2,
			})

			start = b + 1
		end
	end

	return result
end

local function render(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	if not enabled or vim.bo[buf].filetype ~= "markdown" then
		return
	end

	local spoilers = get_spoilers(buf)

	for _, s in ipairs(spoilers) do
		local key = s.row .. ":" .. s.first
		local is_revealed = revealed[buf] and revealed[buf][key]

		-- Style the complete spoiler range.
		vim.api.nvim_buf_set_extmark(buf, ns, s.row, s.first, {
			end_col = s.last,
			hl_group = "MarkdownSpoiler",
			priority = 200,
		})

		if not is_revealed then
			-- Hide the contents, retaining a visible dark block.
			vim.api.nvim_buf_set_extmark(buf, ns, s.row, s.text_first, {
				end_col = s.text_last,
				conceal = " ",
				hl_group = "MarkdownSpoilerHidden",
				priority = 300,
			})
		end
	end
end

local function toggle_at_cursor()
	local buf = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	revealed[buf] = revealed[buf] or {}

	for _, s in ipairs(get_spoilers(buf)) do
		if s.row == row and col >= s.first and col <= s.last then
			local key = s.row .. ":" .. s.first
			revealed[buf][key] = not revealed[buf][key]
			render(buf)
			return
		end
	end
end

function M.setup()
	vim.api.nvim_set_hl(0, "MarkdownSpoiler", {
		bg = "#343434",
	})

	vim.api.nvim_set_hl(0, "MarkdownSpoilerHidden", {
		fg = "#343434",
		bg = "#343434",
	})

	local group = vim.api.nvim_create_augroup("MarkdownSpoilers", { clear = true })

	vim.api.nvim_create_autocmd({
		"BufEnter",
		"TextChanged",
		"TextChangedI",
		"WinEnter",
	}, {
		group = group,
		callback = function(args)
			render(args.buf)
		end,
	})

	vim.keymap.set("n", "<leader>ms", toggle_at_cursor, {
		desc = "Reveal/hide Markdown spoiler",
		buffer = false,
	})

	-- Left-click a spoiler to toggle it.
	vim.keymap.set("n", "<LeftMouse>", function()
		local pos = vim.fn.getmousepos()

		if pos.winid == 0 or pos.line == 0 then
			return
		end

		local win = pos.winid
		local buf = vim.api.nvim_win_get_buf(win)
		local row = pos.line - 1
		local col = pos.column - 1

		if vim.bo[buf].filetype ~= "markdown" then
			vim.cmd.normal({ args = { "zh" }, bang = true })
			return
		end

		local found = false

		for _, s in ipairs(get_spoilers(buf)) do
			if s.row == row and col >= s.first and col <= s.last then
				vim.api.nvim_set_current_win(win)
				vim.api.nvim_win_set_cursor(win, { pos.line, col })
				toggle_at_cursor()
				found = true
				break
			end
		end

		if not found then
			vim.api.nvim_set_current_win(win)
			vim.api.nvim_win_set_cursor(win, { pos.line, col })
		end
	end, { desc = "Click to toggle Markdown spoiler" })
end

return M
