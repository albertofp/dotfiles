return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },

  config = function()
    local ufo = require 'ufo'
    require('ufo').setup {
      provider_selector = function()
        return { 'lsp', 'indent' }
      end,

      vim.keymap.set('n', 'zR', ufo.openAllFolds),
      vim.keymap.set('n', 'zM', ufo.closeAllFolds),
      vim.keymap.set('n', '-', '<cmd>foldclose<CR>', { silent = true, desc = 'Close fold' }),
      vim.keymap.set('n', '+', '<cmd>foldopen<CR>', { silent = true, desc = 'Open fold' }),
      vim.keymap.set('n', 'zK', function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { silent = true, desc = 'Peek fold' }),
    }
  end,
}
