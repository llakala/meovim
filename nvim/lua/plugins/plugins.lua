require("nvim-autopairs").setup()

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
