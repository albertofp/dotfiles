vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('i', 'jk', '<Esc>', { silent = true })
vim.keymap.set('i', 'kj', '<Esc>', { silent = true })

-- Buffers
vim.keymap.set('n', '<leader>x', ':bd <CR>', { desc = 'Close buffer', silent = true })
vim.keymap.set('n', '<leader>b', ':enew <CR>', { desc = 'New buffer', silent = true })
vim.keymap.set('n', '<Tab>', ':bn <CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<S-Tab>', ':bp <CR>', { desc = 'Previous buffer', silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Window navigation
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Window down' })

-- Split window
vim.keymap.set('n', '<leader>vsp', ':vsplit <CR>', { desc = 'Split window vertically', silent = true })
vim.keymap.set('n', '<leader>hsp', ':split <CR>', { desc = 'Split window horizontally', silent = true })

-- Resize window vertically
vim.keymap.set('n', '<C-+>', ':vertical resize +2 <CR>', { desc = 'Increase window height', silent = true })
vim.keymap.set('n', '<C-->', ':vertical resize -2 <CR>', { desc = 'Decrease window height', silent = true })

-- Save file
vim.keymap.set('n', '<C-s>', ':w <CR>', { desc = 'Save file', silent = true })

-- Escape Terminal
vim.keymap.set('t', '<C-x>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
  { desc = 'Escape terminal' })

vim.keymap.set('n', '<A-ESC>', ':%bd|e#|bd# <CR>', { desc = 'Close all buffers except current' })

vim.keymap.set('n', '<C-h>', function()
  require('nvterm.terminal').toggle 'horizontal'
end)
vim.keymap.set('t', '<C-h>', function()
  require('nvterm.terminal').toggle 'horizontal'
end)

-- Go keybinds
vim.keymap.set('n', '<leader>gat', ':GoAddTag json <CR>', { desc = 'Add struct json tags' })
vim.keymap.set('n', '<leader>gfs', ':GoFillStruct <CR>', { desc = 'Fill struct' })
vim.keymap.set('n', '<leader>gie', ':GoIfErr <CR>', { desc = 'if err != nil{}' })
vim.keymap.set('n', '<leader>gg', ':GoGet ', { desc = ':GoGet <package>' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Trouble keybindings
vim.keymap.set('n', '<leader>xx', function()
  require('trouble').open()
end)
vim.keymap.set('n', '<leader>xw', function()
  require('trouble').open 'workspace_diagnostics'
end)
vim.keymap.set('n', '<leader>xd', function()
  require('trouble').open 'document_diagnostics'
end)
vim.keymap.set('n', '<leader>xq', function()
  require('trouble').open 'quickfix'
end)
vim.keymap.set('n', '<leader>xl', function()
  require('trouble').open 'loclist'
end)
vim.keymap.set('n', 'gR', function()
  require('trouble').open 'lsp_references'
end)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr)
-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself
-- many times.
--
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { desc = desc })
end

nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

-- See `:help K` for why this keymap
nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

-- Lesser used LSP functionality
nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
nmap('<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, '[W]orkspace [L]ist Folders')
-- end

local telescope = require 'telescope.builtin'

-- Telescope git keybindings
vim.keymap.set('n', '<leader>gt', telescope.git_status)
vim.keymap.set('n', '<leader>gc', telescope.git_commits)
vim.keymap.set('n', '<leader>gb', telescope.git_branches)

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = true,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>th', telescope.colorscheme, { desc = '[th]emes' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = '[f]ind [b]uffers' })
vim.keymap.set('n', '<leader>gf', telescope.git_files, { desc = 'Search [g]it [f]iles' })
vim.keymap.set('n', '<leader>fa', telescope.find_files, { desc = '[f]ind [a]ll' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = '[f]ind [h]elp' })
vim.keymap.set('n', '<leader>fw', telescope.grep_string, { desc = '[f]ind current [w]ord' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[f]ind by [g]rep' })
vim.keymap.set('n', '<leader>fd', telescope.diagnostics, { desc = '[f]ind [d]iagnostics' })
vim.keymap.set('n', '<leader>fo', telescope.oldfiles, { desc = '[f]ind [o]ld files' })
vim.keymap.set('n', '<leader>ts', telescope.treesitter, { desc = 'Telescope [t]ree[s]itter view' })

-- toggle dark/light mode
vim.keymap.set('n', '<leader>td', ":let &bg=(&bg=='light'?'dark':'light')<cr>",
  { desc = 'Toggle dark/light mode', silent = true })
