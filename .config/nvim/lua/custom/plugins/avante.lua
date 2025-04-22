return {
  -- https://github.com/yetone/avante.nvim
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    provider = "gemini",
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models/",
      model = "gemini-2.5-pro-preview-03-25",
      timeout = 30000,
      temperature = 0,
      -- max_tokens = 4096,
    },
    -- provider = "openai",
    -- openai = {
    --   endpoint = "https://api.openai.com/v1",
    --   -- model = "gpt-4.1-2025-04-14", -- your desired model (or use gpt-4o, etc.)
    --   model = "o3-mini",
    --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    --   temperature = 0,
    --   disable_tools = true,
    --   -- max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    -- },
    windows = {
      width = 40,
      sidebar_header = {
        enabled = false
      },
    },
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons",
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
