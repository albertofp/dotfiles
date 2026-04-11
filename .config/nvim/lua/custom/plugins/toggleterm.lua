return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = nil, -- we define keymaps manually below
      shade_terminals = false,
      persist_mode = true,
    }

    local Terminal = require('toggleterm.terminal').Terminal

    local horizontal_term = Terminal:new { direction = 'horizontal', hidden = true }
    local vertical_term = Terminal:new { direction = 'vertical', hidden = true }
    local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, direction = 'float' }

    vim.keymap.set({ 'n', 't' }, '<C-h>', function() horizontal_term:toggle() end,
      { desc = 'Toggle horizontal terminal', noremap = true, silent = true })
    vim.keymap.set({ 'n', 't' }, '<C-v>', function() vertical_term:toggle() end,
      { desc = 'Toggle vertical terminal', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>m', function() lazygit:toggle() end,
      { desc = 'Toggle lazygit', noremap = true, silent = true })
  end,
}
