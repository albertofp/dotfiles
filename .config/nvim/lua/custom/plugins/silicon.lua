return {
  'michaelrommel/nvim-silicon',
  lazy = false,
  cmd = 'Silicon',
  config = function()
    require('silicon').setup {
      font = 'JetBrainsMono Nerd Font=34',
      background = '#fff0',
      tab_width = 2,
      pad_horiz = 50,
      pad_vert = 40,
      to_clipboard = true,
      no_line_number = true,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
      end,
    }
    vim.keymap.set('v', '<leader>si', ':Silicon<CR>', { desc = 'Silicon' })
  end,
}
