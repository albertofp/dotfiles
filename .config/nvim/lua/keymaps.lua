vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

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
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })

vim.keymap.set('i', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('i', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('i', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('i', '<C-j>', '<C-w>j', { desc = 'Window down' })

-- Save file
vim.keymap.set('n', '<C-s>', ':w <CR>', { desc = 'Save file', silent = true })

-- New file
vim.keymap.set('n', '<A-n>', ':e %:p:h', { desc = 'New file' })

-- Toggle NvimTree
vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>', { desc = 'Toggle File tree', silent = true })

-- Toggle Terminal
vim.keymap.set('n', '<C-h>', function()
  require('nvterm.terminal').toggle 'horizontal'
end)
vim.keymap.set('t', '<C-h>', function()
  require('nvterm.terminal').toggle 'horizontal'
end)

vim.keymap.set('n', '<C-v>', function()
  require('nvterm.terminal').toggle 'vertical'
end)
vim.keymap.set('t', '<C-v>', function()
  require('nvterm.terminal').toggle 'vertical'
end)

-- Escape Terminal
vim.keymap.set('t', '<C-x>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
  { desc = 'Escape terminal' })

vim.keymap.set('n', '<A-ESC>', ':%bd|e#|bd# <CR>', { desc = 'Close all buffers except current' })

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

-- Telescope file browser
vim.api.nvim_set_keymap('n', '<space>ob', ':Telescope file_browser files=false<CR>',
  { noremap = true, desc = '[o]pen file [b]rowser' })

vim.api.nvim_set_keymap(
  'n',
  '<space>fbc',
  ':Telescope file_browser path=%:p:h select_buffer=true<CR>',
  { noremap = true, desc = '[o]pen file [b]rowser with the path of the [c]urrent buffer' }
)

-- Telescope git keybindings
vim.keymap.set('n', '<leader>gt', require('telescope.builtin').git_status)
vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits)
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches)

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = true,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>th', require('telescope.builtin').colorscheme, { desc = '[th]emes' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, { desc = '[F]ind [O]ld files' })
