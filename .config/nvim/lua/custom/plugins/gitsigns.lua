return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      -- add = { text = '+' },
      -- change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>ph', require('gitsigns').prev_hunk,
        { buffer = bufnr, desc = '[p]revious [h]unk' })
      vim.keymap.set('n', '<leader>nh', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[n]ext [h]unk' })
      vim.keymap.set('n', '<leader>pp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[p]review hunk' })
      vim.keymap.set('n', '<leader>dt', require('gitsigns').diffthis, { buffer = bufnr, desc = '[d]iff [t]his' })
      vim.keymap.set('n', '<leader>bl', require('gitsigns').toggle_current_line_blame,
        { buffer = bufnr, desc = '[b]lame [l]ine' })
      -- Text object
      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  },
}
