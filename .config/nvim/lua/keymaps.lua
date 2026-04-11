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
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
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

-- Save file
vim.keymap.set('n', '<C-s>', ':w <CR>', { desc = 'Save file', silent = true })

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
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ LSP keymaps ]]
-- Neovim 0.11+ provides defaults for: grn (rename), gra (code action), grr (references),
-- gri (implementation), grd (definition), K (hover), gD (declaration).
-- Neovim 0.12 adds: grt (type definition), grx (code lens).
-- Below we only define mappings that differ from or extend those defaults.

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = 'LSP: ' .. desc })
end

-- Override gr* with Telescope-powered variants for a richer UI
nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

-- Signature help (not covered by defaults)
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

-- Workspace folder management
nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
nmap('<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, '[W]orkspace [L]ist Folders')

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
vim.keymap.set('n', '<leader>ff', function()
  telescope.find_files { no_ignore = true, hidden = true }
end, { desc = '[f]ind all [f]iles (include ignored)' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = '[f]ind [h]elp' })
vim.keymap.set('n', '<leader>fm', telescope.marks, { desc = '[f]ind [m]arks' })
vim.keymap.set('n', '<leader>fw', telescope.grep_string, { desc = '[f]ind current [w]ord' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[f]ind by [g]rep' })
vim.keymap.set('n', '<leader>fd', telescope.diagnostics, { desc = '[f]ind [d]iagnostics' })
vim.keymap.set('n', '<leader>fo', telescope.oldfiles, { desc = '[f]ind [o]ld files' })

-- toggle dark/light mode
vim.keymap.set('n', '<leader>td', ":let &bg=(&bg=='light'?'dark':'light')<cr>",
  { desc = 'Toggle dark/light mode', silent = true })

-- Resize window width
vim.keymap.set('n', '<leader>+', ':vertical resize +5 <CR>', { desc = 'Increase window width', silent = true })
vim.keymap.set('n', '<leader>-', ':vertical resize -5 <CR>', { desc = 'Decrease window width', silent = true })

-- Resize window height
vim.keymap.set('n', '<leader>h+', ':resize +2 <CR>', { desc = 'Increase window height', silent = true })
vim.keymap.set('n', '<leader>h-', ':resize -2 <CR>', { desc = 'Decrease window height', silent = true })

-- Custom commands

vim.keymap.set('n', '<leader>ut', function()
  if vim.fn.expand('%:t') == 'deployment.yml' or vim.fn.expand('%:t') == 'deployment.yaml' then
    local tag = vim.fn.input("Tag: ")
    vim.cmd("UpdateImageTag " .. tag)
  else
    vim.notify("UpdateImageTag only works on deployment.yml or deployment.yaml files.", vim.log.levels.INFO)
  end
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>yy', ':%y<CR>', { desc = 'Copy file contents to clipboard', silent = true })
vim.keymap.set('n', '<leader>dd', ':%d<CR>', { desc = 'Delete file contents', silent = true })

vim.keymap.set('n', '<leader>std', 'vi"y:SearchTerraformRegistry <C-r>"<CR>',
  { silent = true, desc = "Search TF Registry (text in \")" })

-- nmap <Leader>f <Plug>(prettier-format)
vim.keymap.set('n', '<leader>f', function() require('prettier').format() end,
  { silent = true, desc = "Format with Prettier" })
