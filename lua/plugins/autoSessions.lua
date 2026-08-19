return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,

    config = function()
        require("cyberdream").setup({
            variant = "default",

            -- This is the important part
            transparent = true,

            -- Makes comments look closer to the screenshot
            italic_comments = true,

            -- Use terminal colors
            terminal_colors = true,
        })

        vim.cmd.colorscheme("cyberdream")
        vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
                vim.cmd("AutoSession save")
            end,
        })
    end,
}
-- return {
    --     "folke/tokyonight.nvim",
    --     priority = 1000,
    --
    --     config = function()
        --         vim.cmd.colorscheme("tokyonight-night")
        --     end,
        -- }
