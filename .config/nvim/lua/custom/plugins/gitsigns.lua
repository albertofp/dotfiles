return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  -- https://github.com/lewis6991/gitsigns.nvim
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>ph', require('gitsigns').prev_hunk,
        { buffer = bufnr, desc = '[p]revious [h]unk' })
      vim.keymap.set('n', '<leader>nh', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[n]ext [h]unk' })
      vim.keymap.set('n', '<leader>sh', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[s]tage [h]unk' })
      vim.keymap.set('n', '<leader>pp', require('gitsigns').preview_hunk_inline,
        { buffer = bufnr, desc = '[p]review hunk' })
      vim.keymap.set('n', '<leader>dt', require('gitsigns').diffthis, { buffer = bufnr, desc = '[d]iff [t]his' })
      vim.keymap.set('n', '<leader>bl', require('gitsigns').toggle_current_line_blame,
        { buffer = bufnr, desc = '[b]lame [l]ine' })
      -- Text object
      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
    },
  },
}
