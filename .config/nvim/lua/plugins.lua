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

  -- Telescope
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',

  -- File tree & navigation
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/oil.nvim',

  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/f-person/git-blame.nvim',

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
  'https://github.com/antosha417/nvim-lsp-file-operations',

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
}

-- Simple setup calls with no meaningful options — inlined here instead of separate files
require('nvim-surround').setup {}
require('ibl').setup()
require('lsp-file-operations').setup()
require('nvim-ts-autotag').setup()
require('fidget').setup {}
require('which-key').setup {}
require('gitblame').setup { enabled = false }
require('rose-pine').setup {}
vim.cmd 'colorscheme rose-pine'

-- Build hooks: run shell commands after install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if (kind == 'install' or kind == 'update') then
      -- blink.cmp needs its Rust fuzzy-matching binary built after install/update
      if name == 'blink.cmp' then
        vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }, function(obj)
          if obj.code ~= 0 then
            vim.schedule(function()
              vim.notify('blink.cmp: cargo build failed:\n' .. obj.stderr, vim.log.levels.ERROR)
            end)
          end
        end)
      end
      -- telescope-fzf-native needs `make` after install/update
      if name == 'telescope-fzf-native.nvim' then
        vim.system({ 'make' }, { cwd = ev.data.path })
      end
      -- nvim-treesitter: update parsers after plugin update
      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        vim.cmd('TSUpdate')
      end
    end
  end,
})
