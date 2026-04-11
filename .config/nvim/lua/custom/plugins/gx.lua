return {
  "chrishrb/gx.nvim",
  lazy = false,
  config = function()
    require("gx").setup {
      cmd = { "Browse" },
    }
  end,
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },

}
