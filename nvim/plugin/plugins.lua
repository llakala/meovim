require("gitsigns").setup()

-- Indent blankline
require("ibl").setup({
  scope = { enabled = false },
})

require("nvim-surround").setup({
  move_cursor = "sticky",

  -- I'd like to have these use `ds` to be more vim-appropriate, but they seem
  -- to break which-key when I do them in that order. Gross!
  keymaps = {
    normal = "ss",

    normal_cur = "<A-o>",
    normal_line = "<A-o>",
    normal_cur_line = "<A-o>",

    delete = "sd",

    change = "sc",
    change_line = "sC",
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

require("stay-centered").setup()

require("hlargs").setup()

-- Auto start markdown preview, and change the preview when I change buffers.
g.mkdp_auto_start = 1
g.mkdp_auto_close = 0
g.mkdp_combine_preview = 1
