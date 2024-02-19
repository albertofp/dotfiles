return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
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
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    --https://www.nerdfonts.com/cheat-sheet
    require('nvim-web-devicons').setup {
      strict = true,
      override_by_filename = {
        ['Makefile'] = { icon = '', color = '#ff9900', name = 'Makefile' },
      },
      override_by_extension = {
        ['go'] = {
          icon = '󰟓',
          color = '#00acd7',
          name = 'Go',
        },
        ['mod'] = {
          icon = '󰟓',
          color = '#ff9900',
          name = 'Gomod',
        },
        ['sum'] = {
          icon = '󰟓',
          color = '#ff9900',
          name = 'Gosum',
        },
      },
    },
  },
}

-- ['Makefile'] = { icon = '', color = '#ff9900', name = 'Makefile' },
