return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float", -- Options: "float", "vertical", "horizontal"
    })

    -- Keymap to toggle LazyGit
    vim.keymap.set("n", "<leader>m", function() lazygit:toggle() end, { noremap = true, silent = true })

    require("toggleterm").setup {}
  end
}
