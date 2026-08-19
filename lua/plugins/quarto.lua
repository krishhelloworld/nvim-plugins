return {
    {
        "quarto-dev/quarto-nvim",

        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },

        ft = {
            "quarto",
            "markdown",
        },

        opts = {
            codeRunner = {
                enabled = true,
                default_method = "molten",
            },

            lspFeatures = {
                enabled = true,

                languages = {
                    "python",
                    "julia",
                    "bash",
                    "html",
                },

                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" },
                },

                completion = {
                    enabled = true,
                },
            },
        },

        config = function(_, opts)
            require("quarto").setup(opts)

            local runner = require("quarto.runner")

            vim.keymap.set("n", "<localleader>rc", runner.run_cell, {
                desc = "Run current cell",
            })

            vim.keymap.set("n", "<localleader>ra", runner.run_above, {
                desc = "Run cell and above",
            })

            vim.keymap.set("n", "<localleader>rA", runner.run_all, {
                desc = "Run all cells",
            })
        end,
    },
}
