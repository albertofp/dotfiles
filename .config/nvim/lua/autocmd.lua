-- Terraform filetype detection and settings
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.tf', '*.tfvars' },
  callback = function() vim.bo.filetype = 'terraform' end,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.hcl', '.terraformrc', 'terraform.rc' },
  callback = function() vim.bo.filetype = 'hcl' end,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.tfstate', '*.tfstate.backup' },
  callback = function() vim.bo.filetype = 'json' end,
})

-- vim-terraform settings (fmt on save + align)
vim.g.terraform_fmt_on_save = 1
vim.g.terraform_align = 1

-- Snakefile → Python
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'Snakefile',
  callback = function() vim.bo.filetype = 'python' end,
})

-- Reopen file at last cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was open at',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Treesitter: enable highlighting, folding, and indentation natively.
-- The new nvim-treesitter (0.12 rewrite) no longer provides a configs.setup
-- module; these features are wired up here using the Neovim built-ins.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable treesitter highlighting, folding, and indentation',
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    -- Skip special/non-file buffers
    if ft == '' or vim.bo[args.buf].buftype ~= '' then return end

    -- Highlighting (built into Neovim)
    local ok = pcall(vim.treesitter.start, args.buf)
    if not ok then return end

    -- Folding (built into Neovim; requires foldmethod=expr)
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Indentation (provided by nvim-treesitter plugin, experimental)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Ansible YAML detection
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    '*/playbooks/*.yml',
    '*/playbooks/*.yaml',
    '*/roles/*/tasks/*.yml',
    '*/roles/*/tasks/*.yaml',
    '*/roles/*/handlers/*.yml',
    '*/roles/*/handlers/*.yaml',
  },
  callback = function() vim.bo.filetype = 'yaml.ansible' end,
})
