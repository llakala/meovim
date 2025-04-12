return {
  {
    "indent-blankline.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("ibl").setup({
        scope = { enabled = false },
      })
    end,
  },

  {
    "gitsigns.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("gitsigns").setup()
    end,
  },

  {
    "rainbow-delimiters.nvim",
    after = function()
      -- No, that's not a typo, the string has setup in it
      require("rainbow-delimiters.setup").setup({
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterViolet",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
        },
      })
    end,
  },
}
