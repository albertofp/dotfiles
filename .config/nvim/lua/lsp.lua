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

  gh_actions_ls = {
    filetypes = { 'yaml.github', 'githubactions' },
  },

  astro = {},

  bashls = {},

  html = {},

  docker_compose_language_service = {},

  terraformls = {
    filetypes = { 'tf', 'hcl', 'terraform' },
  },

  gopls = {},

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
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
      format = {
        enable = true,
        -- Stylua
        defaultConfig = {
          indent_width = 2,
          indent_type = 'Spaces',
          quote_style = 'AutoPreferSingle',
          no_call_parentheses = true,
        },
      },
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
  automatic_enable = true,
  ensure_installed = vim.tbl_keys(servers),
}

for server_name, server_config in pairs(servers) do
  vim.lsp.config(server_name, vim.tbl_deep_extend('force', server_config or {}, { capabilities = capabilities }))
end
