return {
  'xiyaowong/transparent.nvim',
  lazy = false,
  config = function()
    require('transparent').setup {
      extra_groups = {
        -- 'NormalFloat',    -- plugins which have float panel such as Lazy, Mason, LspInfo
        'NvimTreeNormal', -- NvimTree
      },
      -- require('transparent').clear_prefix 'lualine',
      require('transparent').clear_prefix 'Bufferline',
      require('transparent').clear_prefix 'GitSigns',

      vim.keymap.set('n', '<leader>tt', require('transparent').toggle),
    }
  end,
}
