require('gx').setup { cmd = { 'Browse' } }
vim.keymap.set({ 'n', 'x' }, 'gx', '<cmd>Browse<cr>')
