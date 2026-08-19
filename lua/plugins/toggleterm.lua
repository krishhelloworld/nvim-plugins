return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 40,
            direction = "vertical",
            start_in_insert = true,
            persist_size = true,
            close_on_exit = false,
            hide_numbers = true,
        })
        local Terminal = require("toggleterm.terminal").Terminal
        -- Keep one terminal for each directory
        local terminals = {}
        -- Get the directory where we are currently working
        local function get_current_dir()
            -- If we are inside Oil.nvim,
            -- use the directory currently displayed by Oil
            if vim.bo.filetype == "oil" then
                return require("oil").get_current_dir()
            end
            -- If we are editing a normal file,
            -- use the directory containing that file
            local file = vim.api.nvim_buf_get_name(0)
            if file ~= "" then
                local dir = vim.fn.fnamemodify(file, ":p:h")
                if vim.fn.isdirectory(dir) == 1 then
                    return dir
                end
            end
            -- Final fallback
            return vim.fn.getcwd()
        end
        -- C++ COMPILE + RUN
        vim.keymap.set("n", "<F6>", function()
            vim.cmd("write")

            local filename = vim.fn.expand("%:t")
            local exe = vim.fn.expand("%:t:r") .. ".exe"
            local dir = vim.fn.expand("%:p:h")
            local input = dir .. "/input.txt"

            local cmd = string.format(
                'g++ -std=c++20 "%s" -o "%s" && "%s"',
                filename,
                exe,
                exe
            )

            -- Use input.txt if it exists
            if vim.fn.filereadable(input) == 1 then
                cmd = cmd .. ' < "input.txt"'
            end

            local Terminal = require("toggleterm.terminal").Terminal
            local term = Terminal:new({
                dir = dir,
                direction = "vertical",
                size = 50,
                close_on_exit = false,
                start_in_insert = true,
            })

            term:toggle()

            vim.defer_fn(function()
                term:send(cmd)
            end, 300)
        end, {
        desc = "Compile and Run C++",
    })
    local function toggle_terminal()
        -- If we are already inside a ToggleTerm terminal,
        -- toggle that terminal instead of creating another one.
        if vim.bo.filetype == "toggleterm" then
            require("toggleterm").toggle()
            return
        end
        local dir = get_current_dir()
        if not dir then
            dir = vim.fn.getcwd()
        end
        -- Create a terminal for this directory if it doesn't exist
        if not terminals[dir] then
            terminals[dir] = Terminal:new({
                dir = dir,
                direction = "vertical",
                size=40,
                start_in_insert = true,
                close_on_exit = false,
            })
        end
        -- Open/close the terminal for this directory
        terminals[dir]:toggle()
    end
    -- Ctrl+\ to open/close terminal
    vim.keymap.set(
        { "n", "t" },
        "<C-\\>",
        toggle_terminal,
        {
            desc = "Toggle Terminal in Current Directory",
        }
    )
end,
}

