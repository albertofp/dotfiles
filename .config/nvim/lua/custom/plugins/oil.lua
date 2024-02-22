return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      default_file_explorer = false,
      experimental_watch_for_changes = true,
    }
    vim.keymap.set('n', '_', ':Oil<CR>', { desc = 'Open parent directory' })
  end,
}
