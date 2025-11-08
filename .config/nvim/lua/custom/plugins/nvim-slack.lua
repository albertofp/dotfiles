return {
  dir = '/Users/albertopluecker/github/nvim-slack',
  name = 'nvim-slack',
  -- 'albertofp/nvim-slack',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('nvim-slack').setup({
      token = 'xoxp-9539866288913-9539866410289-9539910161553-ef6d8854fb47c8074270bef87f67f23f'
    })
  end
}
