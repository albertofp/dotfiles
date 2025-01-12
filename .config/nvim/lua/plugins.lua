local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'rose-pine/neovim',        name = 'rose-pine' },
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'mattn/vim-goaddtags',
  { 'hashivim/vim-terraform',  lazy = true },
  { 'wuelnerdotexe/vim-astro', lazy = true },
  { 'folke/which-key.nvim',    opts = {} },
  { 'numToStr/Comment.nvim',   opts = {} },
  require 'kickstart.plugins.autoformat',
  { import = 'custom.plugins' },
}, {})
