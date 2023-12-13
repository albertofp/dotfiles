vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make cursor stay centered
vim.o.scrolloff = 999

-- Set highlight on search
vim.o.hlsearch = false

vim.wo.number = true
vim.wo.relativenumber = true

-- Set auto indent and tab width
vim.opt_global.tabstop = 2
vim.opt_global.shiftwidth = 2
vim.opt_global.expandtab = true

-- Enable mouse mode
vim.o.mouse = 'a'

--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.opt.virtualedit = 'block'
