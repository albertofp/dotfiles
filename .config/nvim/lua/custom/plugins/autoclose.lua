require('autoclose').setup {
  keys = {
    ["'"] = { escape = true, close = true, pair = "''", disable_command_mode = true },
  },
  options = { pair_spaces = true },
}
