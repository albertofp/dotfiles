return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      log_level = "debug",
      keymaps = {
        accept_suggestion = "<C-g>",
        clear_suggestion = "<C-x]>",
        accept_word = "<C-w>",
      },
      ignore_filetypes = { md = true },
    })
  end,
}
