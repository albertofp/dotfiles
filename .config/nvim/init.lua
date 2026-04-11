require 'options'
require 'plugins' -- calls vim.pack.add{} — all plugins are available after this line
require 'autocmd'
require 'lsp'
require 'keymaps'

-- Load every file under lua/custom/plugins/ as plugin configuration.
-- Files are plain Lua (no lazy spec wrappers); order is alphabetical.
local plugin_dir = vim.fn.stdpath('config') .. '/lua/custom/plugins'
local files = vim.fn.glob(plugin_dir .. '/*.lua', false, true)
table.sort(files)
for _, path in ipairs(files) do
  -- Convert absolute path → module name: strip config root + leading slash + .lua
  local mod = path
      :gsub('^' .. vim.fn.stdpath('config') .. '/lua/', '')
      :gsub('/', '.')
      :gsub('%.lua$', '')
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify('custom/plugins error in ' .. mod .. ':\n' .. err, vim.log.levels.ERROR)
  end
end

-- vim: ts=2 sts=2 sw=2 et
