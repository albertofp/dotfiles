return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  -- nvim-treesitter-textobjects is incompatible with the rewritten plugin.
  -- Textobject motions are handled natively; see autocmd.lua for highlighting.
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath('data') .. '/site',
    }

    require('nvim-treesitter').install {
      'typescript',
      'javascript',
      'go',
      'lua',
      'python',
      'requirements',
      'vimdoc',
      'vim',
      'markdown',
      'markdown_inline',
      'dockerfile',
      'bash',
      'yaml',
      'astro',
      'git_rebase',
      'git_config',
      'gitignore',
      'gitcommit',
      'diff',
      'html',
      'c',
      'css',
      'scss',
    }
  end,
}
