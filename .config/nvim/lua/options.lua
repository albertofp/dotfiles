vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Disable netrw (replaced by nvim-tree / oil)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Keep cursor vertically centered
vim.opt.scrolloff = 999

-- Search
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation: 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Mouse
vim.opt.mouse = 'a'

-- System clipboard
vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

-- 80-char column ruler
vim.opt.colorcolumn = '80'

-- Persistent undo
vim.opt.undofile = true

-- Always show sign column
vim.opt.signcolumn = 'yes'

-- Faster update time (e.g. for gitsigns)
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.termguicolors = true

-- Hide the default mode indicator (lualine shows it instead)
vim.opt.showmode = false

vim.opt.virtualedit = 'block'

-- Folding (nvim-ufo needs foldlevel=99 to start all folds open)
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Hide ~ after end of buffer
vim.opt.fillchars = { eob = ' ' }

-- GitHub Actions filetype for LSP
vim.filetype.add {
  pattern = {
    ['.*/%.github[%w/]+workflows[%w/]+.*%.ya?ml'] = 'yaml.github',
  },
}
