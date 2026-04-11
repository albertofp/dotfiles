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
-- nvim-lspconfig (in runtimepath) provides default cmd/root_patterns for each
-- server via lsp/*.lua files. vim.lsp.config() here only overrides/extends
-- those defaults with our custom settings.
-- mason.nvim installs the binaries; vim.lsp.enable() activates each server.
-- ---------------------------------------------------------------------------

require('mason').setup()

local capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Shared capabilities applied to all servers
vim.lsp.config('*', { capabilities = capabilities })

-- Per-server overrides (only where we differ from lspconfig defaults)
vim.lsp.config('ansiblels', {
  filetypes = { 'yaml.ansible' },
})

vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        black      = { enabled = true },
        pyflakes   = { enabled = false },
        autopep8   = { enabled = false },
        yapf       = { enabled = false },
        pylsp_mypy = { enabled = true },
        pyls_isort = { enabled = true },
      },
    },
  },
})

vim.lsp.config('ts_ls', {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  single_file_support = false,
})

vim.lsp.config('gh_actions_ls', {
  filetypes = { 'yaml.github', 'githubactions' },
})

vim.lsp.config('terraformls', {
  filetypes = { 'tf', 'hcl', 'terraform' },
})

vim.lsp.config('yamlls', {
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
        ['http://json.schemastore.org/composer']        = '/docker-compose*.yaml',
        ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
      },
      editor = { tabSize = 2, formatOnType = true },
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
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
})

vim.lsp.enable {
  'ansiblels',
  'pylsp',
  'ts_ls',
  'dockerls',
  'gh_actions_ls',
  'astro',
  'bashls',
  'html',
  'docker_compose_language_service',
  'terraformls',
  'gopls',
  'postgres_lsp',
  'yamlls',
  'lua_ls',
}
