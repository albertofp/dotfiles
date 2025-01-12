return {
  'ray-x/go.nvim',
  lazy = true,
  dependencies = { -- optional packages
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup {
      lsp_cfg = false,
      lsp_gofumpt = true,
      lsp_codelens = false,
      lsp_inlay_hints = {
        enable = false,
        only_current_line = true,
      },
      goimports = 'golines',
      gofmt = 'gofumpt',
    }
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
