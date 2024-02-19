return {
  'NvChad/nvterm',
  config = function()
    require('nvterm').setup()

    -- Toggle Terminal
    vim.keymap.set('n', '<C-h>', function()
      require('nvterm.terminal').toggle 'horizontal'
    end)
    vim.keymap.set('t', '<C-h>', function()
      require('nvterm.terminal').toggle 'horizontal'
    end)

    vim.keymap.set('n', '<C-v>', function()
      require('nvterm.terminal').toggle 'vertical'
    end)
    vim.keymap.set('t', '<C-v>', function()
      require('nvterm.terminal').toggle 'vertical'
    end)
  end,
}
