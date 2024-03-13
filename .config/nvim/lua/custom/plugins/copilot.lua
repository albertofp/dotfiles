return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
        filetypes = {
          yaml = true,
        },
        keymap = {
          accept = '<C-g>',
          next = '<C-.>',
          prev = '<C-,>',
          dismiss = '<C-x>',
        },
      },
    }
  end,
}
