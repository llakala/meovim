require("gitsigns").setup()

local otter = require("otter")
otter.setup({
  buffers = { set_filetype = true }
})

-- Indent blankline
require("ibl").setup({
  scope = { enabled = false },
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
