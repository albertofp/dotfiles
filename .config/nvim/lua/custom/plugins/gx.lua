return {
  "chrishrb/gx.nvim",
  config = function()
    require("gx").setup {
      cmd = { "Browse" },
    }
  end,
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },

}
