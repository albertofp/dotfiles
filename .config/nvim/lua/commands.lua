vim.cmd [[
  command! -nargs=1 UpdateImageTag execute '%s/\(image:\s\+\S\+:\)\S\+/\1' . escape(<q-args>, '/') . '/g'
]]
