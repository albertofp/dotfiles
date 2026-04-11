require('go').setup {
  lsp_cfg = false,
  lsp_gofumpt = true,
  lsp_codelens = false,
  lsp_inlay_hints = { enable = false, only_current_line = true },
  goimports = 'golines',
  gofmt = 'gofumpt',
}
