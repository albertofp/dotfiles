require('transparent').setup {
  extra_groups = { 'NvimTreeNormal' },
}
require('transparent').clear_prefix 'Bufferline'
require('transparent').clear_prefix 'GitSigns'
vim.keymap.set('n', '<leader>tt', require('transparent').toggle)
