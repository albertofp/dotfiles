return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup {
      default_file_explorer = false,
      use_default_keymaps = false,
    }
    vim.keymap.set('n', '_', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
