require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}

require('nvim-treesitter').install {
  'typescript', 'javascript', 'go', 'lua', 'python', 'requirements',
  'vimdoc', 'vim', 'markdown', 'markdown_inline', 'dockerfile', 'bash',
  'yaml', 'astro', 'git_rebase', 'git_config', 'gitignore', 'gitcommit',
  'diff', 'html', 'c', 'css', 'scss',
}
