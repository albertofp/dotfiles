return {
  "rest-nvim/rest.nvim",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "http",
      callback = function()
        vim.keymap.set("n", "<leader>r", "<cmd>Rest run<cr>", { buffer = true })
      end
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  }
}
