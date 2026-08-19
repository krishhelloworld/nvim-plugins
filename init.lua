-- ========================================
-- Neovim Configuration
-- ========================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Better editing
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Find references
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })

-- Show documentation/type information
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation" })

-- REFRESH THE PAGE OF FILES
vim.opt.autoread = true


vim.keymap.set("n", "<F6>", function()
    vim.cmd("w")

    local file = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")
    local exe = vim.fn.expand("%:p:r") .. ".exe"
    local input = dir .. "/input.txt"

    local cmd = "g++ "
        .. vim.fn.shellescape(file)
        .. " -o "
        .. vim.fn.shellescape(exe)
        .. " && "

    if vim.fn.filereadable(input) == 1 then
        cmd = cmd
            .. vim.fn.shellescape(exe)
            .. " < "
            .. vim.fn.shellescape(input)
    else
        cmd = cmd .. vim.fn.shellescape(exe)
    end

    require("toggleterm").exec(cmd, 12, nil, "horizontal")
end, {
    desc = "Compile and Run C++",
})

-- AUTOMATICALLY  OPEN THE RECENT CLOSED SESSIONS
vim.keymap.set("n", "<leader>ss", ":mksession! mysession.vim<CR>")
vim.keymap.set("n", "<leader>sr", ":source mysession.vim<CR>")
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})


-- Switch between buffers 
vim.keymap.set("n", "<leader>bn", ":enew<CR>")
vim.keymap.set("n", "<leader>bd", ":bd<CR>")
vim.keymap.set("n", "<leader>,", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>.", ":bp<CR>", { desc = "Previous buffer" })-- Don't show mode twice


-- AUTOSESSIONS  
vim.api.nvim_create_user_command("Ar", "AutoSession restore", {})
vim.api.nvim_create_user_command("As", "AutoSession search", {})

vim.opt.showmode = false
-- vim keymap for back to editing to file manager 
-- vim.keymap.set("n", "-", "")
-- ========================================
-- Plugin Manager: lazy.nvim
-- ========================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    { import = "plugins" },
})
