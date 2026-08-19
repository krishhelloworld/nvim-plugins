return {
  "rmagatti/auto-session",
  lazy = false,

  opts = {
    -- Automatically restore the session for the current directory
    auto_restore = true,

    -- Automatically save sessions
    auto_save = true,

    -- Create sessions automatically for directories
    auto_create = true,

    -- Don't create sessions in these directories
    suppressed_dirs = {
      "~/",
      "~/Downloads",
      "~/Desktop",
    },

    -- Show a notification when restoring
    show_auto_restore_notif = true,

    -- Session picker
    session_lens = {
      load_on_setup = true,
    },
  },

  keys = {
    {
      "<leader>ss",
      "<cmd>SessionSave<CR>",
      desc = "Save session",
    },
    {
      "<leader>sr",
      "<cmd>SessionRestore<CR>",
      desc = "Restore session",
    },
    {
      "<leader>sf",
      "<cmd>SessionSearch<CR>",
      desc = "Search sessions",
    },
    {
      "<leader>sd",
      "<cmd>SessionDelete<CR>",
      desc = "Delete session",
    },
  },
}

-- return {
--     "rebelot/kanagawa.nvim",
--     priority = 1000,
--
--     config = function()
--         vim.cmd.colorscheme("kanagawa-wave")
--     end,
-- }
