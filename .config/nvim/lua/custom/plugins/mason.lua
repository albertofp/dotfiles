return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
  },
}
