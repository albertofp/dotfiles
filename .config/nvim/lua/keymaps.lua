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
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end,
  { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end,
  { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ LSP keymaps ]]
local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = 'LSP: ' .. desc })
end

-- Override gr* with fzf-lua powered variants for a richer UI
local fzf = require('fzf-lua')
nmap('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
nmap('gr', fzf.lsp_references, '[G]oto [R]eferences')
nmap('gI', fzf.lsp_implementations, '[G]oto [I]mplementation')
nmap('<leader>D', fzf.lsp_typedefs, 'Type [D]efinition')
nmap('<leader>ds', fzf.lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>ws', fzf.lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')

-- Signature help (not covered by defaults)
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

-- Workspace folder management
nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
nmap('<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, '[W]orkspace [L]ist Folders')

-- Git
vim.keymap.set('n', '<leader>gt', fzf.git_status, { desc = 'Git status' })
vim.keymap.set('n', '<leader>gc', fzf.git_commits, { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gb', fzf.git_branches, { desc = 'Git branches' })

-- Fuzzy find
vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>th', fzf.colorschemes, { desc = '[th]emes' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = '[f]ind [b]uffers' })
vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = 'Search [g]it [f]iles' })
vim.keymap.set('n', '<leader>fa', fzf.files, { desc = '[f]ind [a]ll' })
vim.keymap.set('n', '<leader>ff', function()
  fzf.files { fd_opts = '--hidden --no-ignore' }
end, { desc = '[f]ind all [f]iles (include ignored)' })
vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = '[f]ind [h]elp' })
vim.keymap.set('n', '<leader>fm', fzf.marks, { desc = '[f]ind [m]arks' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = '[f]ind current [w]ord' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = '[f]ind by [g]rep' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document, { desc = '[f]ind [d]iagnostics' })
vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = '[f]ind [o]ld files' })

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

vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end,
  { silent = true, desc = 'Format buffer' })
