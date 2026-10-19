return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		----------------------------------------------------------------
		-- FILES
		----------------------------------------------------------------

		-- Space + a → Pin current file
		vim.keymap.set("n", "<leader>a", function()
			if vim.bo.filetype == "oil" then
				vim.notify("Open a file first", vim.log.levels.WARN)
				return
			end

			local file = vim.api.nvim_buf_get_name(0)

			if file == "" then
				vim.notify("No file to pin", vim.log.levels.WARN)
				return
			end

			harpoon:list():add()

			vim.notify("Pinned file: " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)
		end, {
			desc = "Harpoon: Pin File",
		})

		-- Space + e → Open Harpoon file menu
		vim.keymap.set("n", "<leader>e", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, {
			desc = "Harpoon: File Menu",
		})

		-- Space + 1 → File 1
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end)

		-- Space + 2 → File 2
		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end)

		-- Space + 3 → File 3
		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end)

		-- Space + 4 → File 4
		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end)

		----------------------------------------------------------------
		-- PROJECTS / FOLDERS
		----------------------------------------------------------------

		local projects_file = vim.fn.stdpath("data") .. "/pinned_projects.json"

		local projects = {}

		-- Load saved projects
		local function load_projects()
			if vim.fn.filereadable(projects_file) == 1 then
				local content = table.concat(vim.fn.readfile(projects_file), "\n")

				local ok, data = pcall(vim.json.decode, content)

				if ok and type(data) == "table" then
					projects = data
				end
			end
		end

		-- Save projects
		local function save_projects()
			local file = io.open(projects_file, "w")

			if not file then
				vim.notify("Could not save projects", vim.log.levels.ERROR)
				return
			end

			file:write(vim.json.encode(projects))
			file:close()
		end

		load_projects()

		-- Space + A → Pin current folder
		vim.keymap.set("n", "<leader>A", function()
			local dir

			-- If inside Oil, get Oil's current directory
			if vim.bo.filetype == "oil" then
				local ok, oil = pcall(require, "oil")

				if ok then
					dir = oil.get_current_dir()
				end
			end

			-- Otherwise use current file's directory
			if not dir or dir == "" then
				local file = vim.api.nvim_buf_get_name(0)

				if file ~= "" then
					dir = vim.fn.fnamemodify(file, ":p:h")
				end
			end

			-- Fallback to cwd
			if not dir or dir == "" then
				dir = vim.fn.getcwd()
			end

			dir = vim.fn.fnamemodify(dir, ":p")

			-- Don't add duplicate project
			for _, project in ipairs(projects) do
				if project.path == dir then
					vim.notify("Project already pinned: " .. dir, vim.log.levels.WARN)
					return
				end
			end

			table.insert(projects, {
				name = vim.fn.fnamemodify(dir, ":t"),
				path = dir,
			})

			save_projects()

			vim.notify("Pinned project: " .. vim.fn.fnamemodify(dir, ":t"), vim.log.levels.INFO)
		end, {
			desc = "Pin Current Folder",
		})

		-- Space + p → Open project menu
		vim.keymap.set("n", "<leader>p", function()
			if #projects == 0 then
				vim.notify("No pinned projects", vim.log.levels.WARN)
				return
			end

			vim.ui.select(projects, {
				prompt = "Pinned Projects:",
				format_item = function(project)
					return project.name .. "  →  " .. project.path
				end,
			}, function(project, index)
				if not project then
					return
				end

				-- Change Neovim working directory
				vim.cmd("cd " .. vim.fn.fnameescape(project.path))

				-- Open the project directory in Oil
				local ok, oil = pcall(require, "oil")

				if ok then
					oil.open(project.path)
				else
					vim.cmd("edit " .. vim.fn.fnameescape(project.path))
				end

				vim.notify("Opened project: " .. project.name, vim.log.levels.INFO)
			end)
		end, {
			desc = "Open Pinned Project",
		})

		-- Space + P → Delete a pinned project
		vim.keymap.set("n", "<leader>P", function()
			if #projects == 0 then
				vim.notify("No pinned projects", vim.log.levels.WARN)
				return
			end

			vim.ui.select(projects, {
				prompt = "Delete Project:",
				format_item = function(project)
					return project.name
				end,
			}, function(project, index)
				if not index then
					return
				end

				table.remove(projects, index)

				save_projects()

				vim.notify("Removed project: " .. project.name, vim.log.levels.INFO)
			end)
		end, {
			desc = "Delete Pinned Project",
		})
	end,
}
