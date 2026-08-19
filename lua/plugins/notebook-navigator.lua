return {
    {
        "GCBallesteros/NotebookNavigator.nvim",

        dependencies = {
            "benlubas/molten-nvim",
        },

        opts = {
            repl_provider = "molten",
        },

        keys = {
            {
                "<leader>x",
                function()
                    require("notebook-navigator").run_cell()
                end,
                desc = "Run notebook cell",
            },

            {
                "]h",
                function()
                    require("notebook-navigator").move_cell("d")
                end,
                desc = "Next notebook cell",
            },

            {
                "[h",
                function()
                    require("notebook-navigator").move_cell("u")
                end,
                desc = "Previous notebook cell",
            },
        },
    },
}
