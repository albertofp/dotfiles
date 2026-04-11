require('nvim-tree').setup {
  view = {
    side = 'right',
    signcolumn = 'no',
  },
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    dotfiles = false,
  },
}
vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>', { desc = 'Toggle File tree', silent = true })

require('nvim-web-devicons').setup {
  strict = true,
  override_by_filename = {
    ['Makefile'] = { icon = '', color = '#ff9900', name = 'Makefile' },
  },
  override_by_extension = {
    ['go']  = { icon = '󰟓', color = '#00acd7', name = 'Go' },
    ['mod'] = { icon = '󰟓', color = '#ff9900', name = 'Gomod' },
    ['sum'] = { icon = '󰟓', color = '#ff9900', name = 'Gosum' },
  },
}
