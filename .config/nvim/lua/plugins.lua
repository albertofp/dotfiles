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
  {
    "folke/lazydev.nvim",
    -- ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { 'rose-pine/neovim',        name = 'rose-pine' },
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'mattn/vim-goaddtags',
  { 'hashivim/vim-terraform',  lazy = true },
  { 'wuelnerdotexe/vim-astro', lazy = true },
  { 'folke/which-key.nvim',    opts = {} },
  { 'numToStr/Comment.nvim',   opts = {} },
  require 'kickstart.plugins.autoformat',
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        ['yaml.github'] = { 'actionlint' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  { import = 'custom.plugins' },
}, {})
