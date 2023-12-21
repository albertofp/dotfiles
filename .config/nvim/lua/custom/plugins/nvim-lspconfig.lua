return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls' },
      }
    end,
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      lspconfig.lua_ls.setup {}
    end,
    dependencies = {
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      'folke/neodev.nvim',
    },
    opts = { inlay_hints = { enabled = true } },
    require('lspconfig').terraformls.setup {},
    require('lspconfig').tflint.setup {},
    require('lspconfig').lua_ls.setup {},
  },
}
