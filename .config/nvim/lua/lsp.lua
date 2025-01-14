local on_attach = function(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


local ts_plugin_path = '/Users/albertopluecker/.nvm/versions/node/v20.8.1/lib/node_modules/@vue/typescript-plugin'
local servers = {

  ansiblels = {
    filetypes = { 'yaml.ansible' },
  },

  pylsp = {
    pylsp = {
      plugins = {
        black = { enabled = true },
        pyflakes = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        pylsp_mypy = { enabled = true },
        pyls_isort = { enabled = true },
      }
    }
  },

  ts_ls = {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = ts_plugin_path,
          languages = { 'vue' },
        },
      },
    }
  },

  dockerls = {},

  astro = {},

  bashls = {},

  html = {},

  docker_compose_language_service = {},

  terraformls = {
    filetypes = { 'tf', 'hcl', 'terraform' },
  },

  yamlls = {
    filetypes = { 'yaml', 'yaml.ansible' },
    settings = {
      yaml = {
        format = {
          enable = true,
          singleQuote = true,
          bracketSpacing = true,
          printWidth = 80,
          proseWrap = 'preserve',
        },
        validate = true,
        completion = true,
        schemaStore = {
          enable = true,
          url = 'https://www.schemastore.org/api/json/catalog.json',
        },
        schemas = {
          ['http://json.schemastore.org/composer'] = '/docker-compose*.yaml',
          ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        },
        editor = {
          tabSize = 2,
          formatOnType = true,
        },
      }
    }
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
    },
  },

  -- cssls = {
  --   filetypes = { 'css', 'scss', 'less', 'vue' },
  --   css = {
  --     validate = true,
  --   },
  --   -- css = { validate = true },
  -- },

  vuels = {
    filetypes = { 'vue' },
    init_options = {
      config = {
        vetur = {
          useWorkspaceDependencies = true,
          validation = {
            template = true,
            style = true,
            script = true
          }
        }
      }
    }
  }
}

local capabilities = require('blink.cmp').get_lsp_capabilities()
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

local gocfg = require 'go.lsp'.config()
require('lspconfig').gopls.setup(gocfg)
