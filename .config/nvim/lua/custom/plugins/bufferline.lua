return {
  'akinsho/bufferline.nvim',
  config = function()
    require('bufferline').setup {
      options = {
        always_show_bufferline = false,
      }
    }
  end,
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
}
