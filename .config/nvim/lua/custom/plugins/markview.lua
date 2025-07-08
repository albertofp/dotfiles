return {
  "OXY2DEV/markview.nvim",
  -- https://github.com/OXY2DEV/markview.nvim
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH

    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("markview").setup {
      experimental = { check_rtp_message = false },
      preview = {
        enable = false,
        icon_provider = "devicons"
      }
    }
  end
}
