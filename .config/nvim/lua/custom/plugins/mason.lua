return {
  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup()
    end,
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
    },
  },
}
