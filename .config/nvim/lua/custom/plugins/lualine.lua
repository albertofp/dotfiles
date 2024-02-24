return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        disabled_filetypes = { 'NvimTree', 'Oil' },
        section_separators = '',
        component_separators = '',
        extensions = {
          'lazy',
          'fugitive',
          'trouble',
          'mason',
        },
      },
    }
  end,
}
