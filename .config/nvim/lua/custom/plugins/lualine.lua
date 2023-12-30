return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      disabled_filetypes = { 'NvimTree' },
      component_separators = '|',
      extensions = {
        'lazy',
        'fugitive',
        'trouble',
        'mason',
      },
    },
  },
}
