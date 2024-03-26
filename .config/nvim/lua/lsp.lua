local on_attach = function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local servers = {

  -- yamlls = {},

  gopls = {
    lsp_cfg = false,
    lsp_gofumpt = true,
    lsp_codelens = false,
    lsp_inlay_hints = {
      enabled = false,
    },
    goimports = 'golines',
    luasnip = true,
  },

  ansiblels = {
    filetypes = { 'yaml.ansible' },
  },

  pylsp = {
    plugins = {
      black = { enabled = true },
      pylsp_mypy = { enabled = true },
      pyls_isort = { enabled = true },
    }
  },

  tsserver = {},

  dockerls = {},

  astro = {},

  bashls = {},

  html = {},

  docker_compose_language_service = {},

  terraformls = {
    filetypes = { 'tf', 'hcl', 'terraform' },
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
    },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- require('lspconfig').gopls.setup {
--   lsp_cfg = false,
--   lsp_gofumpt = true,
--   lsp_codelens = false,
--   lsp_inlay_hints = {
--     enabled = false,
--   },
--   goimport = 'golines',
--   luasnip = true,
--   capabilities = capabilities,
--   on_attach = on_attach,
--   filetypes = { 'go', 'gomod' },
-- }
