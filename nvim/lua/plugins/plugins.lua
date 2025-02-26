require("gitsigns").setup()

-- Indent blankline
require("ibl").setup({
  scope = { enabled = false },
})

-- Completion in commandline
-- If you're getting weird Python errors and have yarp installed, run:
-- `:UpdateRemotePlugins` and restart
require("wilder").setup({
  modes = { ':', '/', '?' }
})

-- No, that's not a typo, the string has setup in it
require("rainbow-delimiters.setup").setup({
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterViolet",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
  },
})

require("nvim-treesitter.configs").setup
{
  highlight =
  {
    enable = true,
  },
}
