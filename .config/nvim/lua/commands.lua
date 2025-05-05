require('custom.commands.terraform_registry')

vim.cmd [[
  command! -nargs=1 UpdateImageTag
    \ if expand('%:t') == 'deployment.yml' || expand('%:t') == 'deployment.yaml' |
    \   execute '%s/\(image:\s\+\S\+:\)\S\+/\1' . escape(<q-args>, '/') . '/g' |
    \ else |
    \   echoerr "UpdateImageTag only works on deployment.yml or deployment.yaml files." |
    \ endif
]]
