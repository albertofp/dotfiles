return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  config = function()
    require("silicon").setup({
      font = "JetBrainsMono Nerd Font=34;Noto Color Emoji=34",
      to_clipboard = true,
      no_line_number = true,
      output = "~/Pictures",
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_get_current_buf(), ":t")
      end
    })
    vim.keymap.set("v", "<leader>si", ":Silicon<CR>", { desc = "Silicon" })
  end
}
