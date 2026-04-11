-- lazydev.nvim: LuaLS configuration for editing Neovim config/plugins
-- Only loaded for Lua files via FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  once = false,
  callback = function()
    require('lazydev').setup {
      library = {
        -- Load luvit types when `vim.uv` is referenced
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    }
  end,
})
