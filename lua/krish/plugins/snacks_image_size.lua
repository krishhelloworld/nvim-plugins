local M = {}

local function get_dimensions()
	local buf = vim.api.nvim_get_current_buf()

	if vim.bo[buf].filetype ~= "markdown" then
		return {}
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]
	local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

	if not line then
		return {}
	end

	-- Match standard Markdown image syntax.
	local start_pos, end_pos = line:find("!%b[]%b()")

	if not start_pos then
		return {}
	end

	-- Find optional sizing attributes after the image.
	local attr_start, attr_end = line:find("{[^{}]*}", end_pos + 1)

	if not attr_start then
		return {}
	end

	local attrs = line:sub(attr_start, attr_end)

	local width = tonumber(attrs:match("width%s*=%s*(%d+)"))
	local height = tonumber(attrs:match("height%s*=%s*(%d+)"))

	local result = {}

	if width and width > 0 then
		result.max_width = width
	end

	if height and height > 0 then
		result.max_height = height
	end

	return result
end

function M.setup()
	local doc = require("snacks.image.doc")

	if doc._size_extension_enabled then
		return
	end

	doc._size_extension_enabled = true

	local original_hover = doc.hover

	doc.hover = function(...)
		local config = Snacks.image.config.doc
		local dimensions = get_dimensions()

		local old_width = config.max_width
		local old_height = config.max_height

		config.max_width = dimensions.max_width or old_width
		config.max_height = dimensions.max_height or old_height

		local ok, result = pcall(original_hover, ...)

		config.max_width = old_width
		config.max_height = old_height

		if not ok then
			error(result)
		end

		return result
	end
end

return M
