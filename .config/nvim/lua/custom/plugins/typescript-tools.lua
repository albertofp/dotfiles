return {
  {
    'pmizio/typescript-tools.nvim',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
