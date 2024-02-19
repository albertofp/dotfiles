return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
    'nvim-treesitter/nvim-treesitter',
  },

  config = function()
    local ufo = require 'ufo'
    require('ufo').setup {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,

      vim.keymap.set('n', 'zR', ufo.openAllFolds),
      vim.keymap.set('n', 'zM', ufo.closeAllFolds),
      vim.keymap.set('n', '-', '<cmd>foldclose<CR>', { silent = true, desc = 'Close fold' }),
      vim.keymap.set('n', '+', '<cmd>foldopen<CR>', { silent = true, desc = 'Open fold' }),
    }
  end,
}
