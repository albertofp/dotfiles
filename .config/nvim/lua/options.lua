vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make cursor stay centered
vim.o.scrolloff = 999

vim.o.hlsearch = false

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt_global.tabstop = 2
vim.opt_global.shiftwidth = 2
vim.opt_global.expandtab = true

-- Enable mouse mode
vim.o.mouse = 'a'

--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

-- Line length marker at 80 characters
vim.o.colorcolumn = '80'

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

vim.o.termguicolors = true

-- Hides default mode indicator
vim.cmd 'set noshowmode'

vim.opt.virtualedit = 'block'

-- Folding
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Eliminates the ~ after EOF
vim.opt.fillchars = { eob = ' ' }
