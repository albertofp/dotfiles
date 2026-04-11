local ts_plugin_path = '/Users/albertopluecker/.nvm/versions/node/v20.8.1/lib/node_modules/@vue/typescript-plugin'

-- ---------------------------------------------------------------------------
-- Format on save
-- ---------------------------------------------------------------------------
local format_is_enabled = true
vim.api.nvim_create_user_command('FormatToggle', function()
  format_is_enabled = not format_is_enabled
  vim.notify('Autoformatting: ' .. tostring(format_is_enabled))
end, {})

local _augroups = {}
local function get_augroup(client)
  if not _augroups[client.id] then
    local id = vim.api.nvim_create_augroup('lsp-format-' .. client.name, { clear = true })
    _augroups[client.id] = id
  end
  return _augroups[client.id]
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach-format', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.server_capabilities.documentFormattingProvider then return end
    if client.name == 'ts_ls' then return end -- tsserver formats poorly; use prettier instead

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = get_augroup(client),
      buffer = args.buf,
      callback = function()
        if not format_is_enabled then return end
        vim.lsp.buf.format {
          async = false,
          filter = function(c) return c.id == client.id end,
        }
      end,
    })
  end,
})

-- Inlay hints (global)
vim.lsp.inlay_hint.enable(true)

-- ---------------------------------------------------------------------------
-- Linting
-- ---------------------------------------------------------------------------
require('lint').linters_by_ft = {
  ['yaml.github'] = { 'actionlint' },
}
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function() require('lint').try_lint() end,
})

-- ---------------------------------------------------------------------------
-- LSP servers
-- ---------------------------------------------------------------------------
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
      },
    },
  },

  ts_ls = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = ts_plugin_path,
          languages = { 'vue' },
        },
      },
    },
    single_file_support = false,
  },

  dockerls = {},
  gh_actions_ls = { filetypes = { 'yaml.github', 'githubactions' } },
  astro = {},
  bashls = {},
  html = {},
  docker_compose_language_service = {},
  terraformls = { filetypes = { 'tf', 'hcl', 'terraform' } },
  gopls = {},
  postgres_lsp = {},

  yamlls = {
    filetypes = { 'yaml', 'yaml.ansible' },
    settings = {
      yaml = {
        format = {
          enable = false,
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
          ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
        },
        editor = { tabSize = 2, formatOnType = true },
      },
    },
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
      format = {
        enable = true,
        defaultConfig = {
          indent_width = 2,
          indent_type = 'Spaces',
          quote_style = 'AutoPreferSingle',
          no_call_parentheses = true,
        },
      },
    },
  },
}

-- mason must be set up before mason-lspconfig
require('mason').setup()

local capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- ensure_installed was removed: mason-lspconfig v2 requires Mason package names
-- (e.g. "lua-language-server"), not lspconfig names ("lua_ls"). Use :Mason to
-- install servers manually. automatic_enable = true starts any installed server
-- that has a matching vim.lsp.config() entry below.
require('mason-lspconfig').setup {
  automatic_enable = true,
}

for server_name, server_config in pairs(servers) do
  vim.lsp.config(server_name, vim.tbl_deep_extend('force', server_config, { capabilities = capabilities }))
end
