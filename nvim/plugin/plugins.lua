require("gitsigns").setup()

-- Indent blankline
require("ibl").setup({
  scope = { enabled = false },
})

require("nvim-surround").setup({
  move_cursor = "sticky",
  keymaps = {
    normal = "s",
    delete = "ds",
    change = "cs",
  },
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

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
})

require("hlargs").setup()

-- Auto start markdown preview, and change the preview when I change buffers.
g.mkdp_auto_start = 1
g.mkdp_auto_close = 0
g.mkdp_combine_preview = 1
