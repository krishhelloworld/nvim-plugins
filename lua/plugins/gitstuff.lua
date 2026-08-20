return {
    -- =========================================================
    -- Fugitive
    -- =========================================================
    {
        "tpope/vim-fugitive",

        config = function()
            vim.keymap.set(
                "n",
                "<leader>gg",
                "<cmd>tabnew | Git | only<cr>",
                { desc = "Git status" }
            )

            local group = vim.api.nvim_create_augroup("myFugitive", {})

            vim.api.nvim_create_autocmd("BufWinEnter", {
                group = group,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local opts = {
                        buffer = true,
                        remap = false,
                    }

                    -- Push
                    vim.keymap.set("n", "<leader>gP", function()
                        vim.cmd.Git("push")
                    end, vim.tbl_extend("force", opts, {
                        desc = "Git push",
                    }))

                    -- Pull with rebase
                    vim.keymap.set("n", "<leader>gl", function()
                        vim.cmd.Git({ "pull", "--rebase" })
                    end, vim.tbl_extend("force", opts, {
                        desc = "Git pull --rebase",
                    }))
                end,
            })
        end,
    },

    -- =========================================================
    -- Gitsigns
    -- =========================================================
    {
        "lewis6991/gitsigns.nvim",

        event = {
            "BufReadPre",
            "BufNewFile",
        },

        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, key, action, desc)
                    vim.keymap.set(mode, key, action, {
                        buffer = bufnr,
                        desc = desc,
                    })
                end

                -- Navigate changes
                map("n", "]h", gs.next_hunk, "Next hunk")
                map("n", "[h", gs.prev_hunk, "Previous hunk")

                -- Stage / reset
                map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")

                map("v", "<leader>gs", function()
                    gs.stage_hunk({
                        vim.fn.line("."),
                        vim.fn.line("v"),
                    })
                end, "Stage selected lines")

                map("v", "<leader>gr", function()
                    gs.reset_hunk({
                        vim.fn.line("."),
                        vim.fn.line("v"),
                    })
                end, "Reset selected lines")

                -- Whole file
                map("n", "<leader>gS", gs.stage_buffer, "Stage file")
                map("n", "<leader>gR", gs.reset_buffer, "Reset file")

                -- Inspect
                map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>gd", gs.diffthis, "Diff file")
                map("n", "<leader>gb", function()
                    gs.blame_line({ full = true })
                end, "Blame line")
                map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle blame")

                -- Hunk text object
                map(
                    { "o", "x" },
                    "ih",
                    ":<C-U>Gitsigns select_hunk<CR>",
                    "Git hunk"
                )
            end,
        },
    },

    -- =========================================================
    -- Git Worktree
    -- =========================================================
    {
        "ThePrimeagen/git-worktree.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },

        config = function()
            local gitworktree = require("git-worktree")

            gitworktree.setup()

            require("telescope").load_extension("git_worktree")

            vim.keymap.set(
                "n",
                "<leader>gw",
                function()
                    require("telescope").extensions.git_worktree.git_worktrees()
                end,
                { desc = "Git worktrees" }
            )

            vim.keymap.set(
                "n",
                "<leader>gW",
                function()
                    require("telescope").extensions.git_worktree.create_git_worktree()
                end,
                { desc = "Create git worktree" }
            )
        end,
    },
}
