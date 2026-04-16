-- Build hooks: run shell commands after install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if (kind == 'install' or kind == 'update') then
      if name == 'blink.cmp' then
        vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }, function(obj)
          if obj.code ~= 0 then
            vim.schedule(function()
              vim.notify('blink.cmp: cargo build failed:\n' .. obj.stderr, vim.log.levels.ERROR)
            end)
          end
        end)
      end
      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        vim.cmd('TSUpdate')
      end
    end
  end,
})

vim.pack.add {
  -- LSP & completion
  -- nvim-lspconfig: passive data provider — its lsp/*.lua files supply default
  -- cmd/root_patterns consumed by vim.lsp.config without any require() calls
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/folke/lazydev.nvim',

  -- Treesitter
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- Fuzzy finder
  'https://github.com/ibhagwan/fzf-lua',

  -- File tree & navigation
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/oil.nvim',

  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Terminal
  'https://github.com/akinsho/toggleterm.nvim',

  -- UI
  'https://github.com/rose-pine/neovim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/xiyaowong/transparent.nvim',
  'https://github.com/folke/which-key.nvim',

  -- Diagnostics
  'https://github.com/folke/trouble.nvim',

  -- Editing
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/m4xshen/autoclose.nvim',
  'https://github.com/windwp/nvim-ts-autotag',

  -- LSP extras
  'https://github.com/mfussenegger/nvim-lint',

  -- Language-specific
  'https://github.com/ray-x/go.nvim',
  'https://github.com/ray-x/guihua.lua',
  'https://github.com/hashivim/vim-terraform',
  'https://github.com/mfussenegger/nvim-ansible',
  'https://github.com/lervag/vimtex',

  -- Folding
  'https://github.com/kevinhwang91/nvim-ufo',
  'https://github.com/kevinhwang91/promise-async',

  -- Markdown / docs
  'https://github.com/OXY2DEV/markview.nvim',
  'https://github.com/brianhuster/live-preview.nvim',

  -- Misc
  'https://github.com/chrishrb/gx.nvim',
  'https://github.com/michaelrommel/nvim-silicon',
  'https://github.com/github/copilot.vim',
  'https://github.com/nickjvandyke/opencode.nvim',
}

-- ---------------------------------------------------------------------------
-- Plugin configuration
-- ---------------------------------------------------------------------------

-- Colourscheme (set early so other plugins inherit the palette)
require('rose-pine').setup {}
vim.cmd 'colorscheme rose-pine'

-- Completion
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },
  signature = { enabled = true },
}

-- lazydev: configure lua_ls for Neovim config editing (only on lua files)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    require('lazydev').setup {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    }
  end,
})

-- Treesitter
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}
require('nvim-treesitter').install {
  'typescript', 'javascript', 'go', 'lua', 'python', 'requirements',
  'vimdoc', 'vim', 'markdown', 'markdown_inline', 'dockerfile', 'bash',
  'yaml', 'astro', 'git_rebase', 'git_config', 'gitignore', 'gitcommit',
  'diff', 'html', 'c', 'css', 'scss',
}

-- fzf-lua
require('fzf-lua').setup {
  winopts = {
    layout = 'vertical',
    preview = {
      layout = 'horizontal',
      horizontal = 'right:60%',
    },
  },
  files = {
    cmd = 'rg --files --hidden -g "!.git" -g "!**/vendor/**"',
  },
  grep = {
    rg_opts = '--hidden --glob "!.git" --column --line-number --no-heading --color=always',
  },
  file_ignore_patterns = { 'node_modules', '^.git/', 'vendor/', 'appdev/' },
}

-- File tree
require('nvim-tree').setup {
  view = { side = 'right', signcolumn = 'no' },
  git = { enable = true, ignore = false },
  filters = { dotfiles = false },
}
vim.keymap.set('n', '<C-n>', ':NvimTreeFindFileToggle<CR>', { desc = 'Toggle file tree', silent = true })

require('nvim-web-devicons').setup {
  strict = true,
  override_by_filename = {
    ['Makefile'] = { icon = '', color = '#ff9900', name = 'Makefile' },
  },
  override_by_extension = {
    ['go']  = { icon = '󰟓', color = '#00acd7', name = 'Go' },
    ['mod'] = { icon = '󰟓', color = '#ff9900', name = 'Gomod' },
    ['sum'] = { icon = '󰟓', color = '#ff9900', name = 'Gosum' },
  },
}

-- Oil
require('oil').setup {
  default_file_explorer = false,
  experimental_watch_for_changes = true,
  columns = { 'icon' },
  view_options = { show_hidden = true },
}
vim.keymap.set('n', '_', ':Oil<CR>', { desc = 'Open parent directory', silent = true })

-- Git
require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    vim.keymap.set('n', '<leader>ph', function() gs.nav_hunk('prev') end, { buffer = bufnr, desc = '[p]revious [h]unk' })
    vim.keymap.set('n', '<leader>nh', function() gs.nav_hunk('next') end, { buffer = bufnr, desc = '[n]ext [h]unk' })
    vim.keymap.set('n', '<leader>sh', gs.stage_hunk, { buffer = bufnr, desc = '[s]tage [h]unk' })
    vim.keymap.set('n', '<leader>pp', gs.preview_hunk_inline, { buffer = bufnr, desc = '[p]review hunk' })
    vim.keymap.set('n', '<leader>dt', gs.diffthis, { buffer = bufnr, desc = '[d]iff [t]his' })
    vim.keymap.set('n', '<leader>bl', gs.toggle_current_line_blame, { buffer = bufnr, desc = '[b]lame [l]ine' })
    vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
  current_line_blame = true,
  current_line_blame_opts = { delay = 500, virt_text_pos = 'right_align' },
}

-- Terminal
local Terminal = require('toggleterm.terminal').Terminal
require('toggleterm').setup {
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
  shade_terminals = false,
  persist_mode = true,
}
local horizontal_term = Terminal:new { direction = 'horizontal', hidden = true }
local vertical_term   = Terminal:new { direction = 'vertical', hidden = true }
local float_term      = Terminal:new {
  direction = 'float',
  hidden = true,
  float_opts = {
    border = 'curved',
    width = function() return math.floor(vim.o.columns * 0.85) end,
    height = function() return math.floor(vim.o.lines * 0.85) end,
  },
}
local lazygit         = Terminal:new { cmd = 'lazygit', hidden = true, direction = 'float' }
vim.keymap.set({ 'n', 't' }, '<C-h>', function() horizontal_term:toggle() end,
  { desc = 'Toggle horizontal terminal', noremap = true, silent = true })
vim.keymap.set({ 'n', 't' }, '<C-v>', function() vertical_term:toggle() end,
  { desc = 'Toggle vertical terminal', noremap = true, silent = true })
vim.keymap.set({ 'n', 't' }, '<C-t>', function() float_term:toggle() end,
  { desc = 'Toggle floating terminal', noremap = true, silent = true })
vim.keymap.set('n', '<leader>m', function() lazygit:toggle() end,
  { desc = 'Toggle lazygit', noremap = true, silent = true })

-- UI
require('lualine').setup {
  options = {
    icons_enabled = true,
    disabled_filetypes = { 'NvimTree', 'Oil' },
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  extensions = { 'fugitive', 'trouble', 'mason' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {}, lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {}, lualine_z = {},
  },
}

require('transparent').setup { extra_groups = { 'NvimTreeNormal' } }
require('transparent').clear_prefix 'Bufferline'
require('transparent').clear_prefix 'GitSigns'
vim.keymap.set('n', '<leader>tt', require('transparent').toggle)

require('ibl').setup()
require('fidget').setup {}
require('which-key').setup {}

-- Diagnostics
require('trouble').setup {
  modes = {
    preview_float = {
      mode = 'diagnostics',
      preview = {
        type = 'float',
        relative = 'editor',
        border = 'rounded',
        title = 'Preview',
        title_pos = 'center',
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
  },
}
vim.keymap.set('n', '<leader>vv', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>vV', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = 'LSP Definitions / references / ...' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

-- Editing
require('nvim-surround').setup {}
require('autoclose').setup {
  keys = {
    ["'"] = { escape = true, close = true, pair = "''", disable_command_mode = true },
  },
  options = { pair_spaces = true },
}
require('nvim-ts-autotag').setup()
---@diagnostic disable-next-line: missing-fields
require('gx').setup {}
vim.keymap.set({ 'n', 'x' }, 'gx', '<cmd>Browse<cr>')

-- LSP extras

-- Language-specific
require('go').setup {
  lsp_cfg = false,
  lsp_gofumpt = true,
  lsp_codelens = false,
  lsp_inlay_hints = { enable = false, only_current_line = true },
  goimports = 'golines',
  gofmt = 'gofumpt',
}

-- vimtex (globals must be set before plugin loads)
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'

-- Folding
local ufo = require('ufo')
require('ufo').setup {
  provider_selector = function() return { 'lsp', 'indent' } end,
}
vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)
vim.keymap.set('n', '-', '<cmd>foldclose<CR>', { silent = true, desc = 'Close fold' })
vim.keymap.set('n', '+', '<cmd>foldopen<CR>', { silent = true, desc = 'Open fold' })
vim.keymap.set('n', 'zK', function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then vim.lsp.buf.hover() end
end, { silent = true, desc = 'Peek fold' })

-- Markdown
---@diagnostic disable-next-line: missing-fields
require('markview').setup {
  ---@diagnostic disable-next-line: missing-fields
  experimental = { check_rtp_message = false },
  preview = { enable = true, icon_provider = 'devicons', map_gx = false },
}

-- Silicon (code screenshots)
require('nvim-silicon').setup {
  font = 'JetBrainsMono Nerd Font=34',
  background = '#fff0',
  tab_width = 2,
  pad_horiz = 50,
  pad_vert = 40,
  to_clipboard = true,
  output = function()
    return './' .. os.date('!%Y-%m-%dT%H-%M-%SZ') .. '_code.png'
  end,
  no_line_number = true,
  window_title = function()
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
  end,
}
vim.keymap.set('v', '<leader>si', ':Silicon<CR>', { desc = 'Silicon' })

-- <C-a>/<C-x> remapped to opencode above; restore increment/decrement on +/-
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment under cursor', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement under cursor', noremap = true })
