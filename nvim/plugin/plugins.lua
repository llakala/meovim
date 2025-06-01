require("gitsigns").setup()

-- Indent blankline
require("ibl").setup({
  scope = { enabled = false },
})

require("nvim-surround").setup({
  move_cursor = "sticky",

  -- We disable all the default keymaps, instead choosing to access
  -- nvim-surround through `surround-ui` (or, actually, my fork that makes
  -- surround-ui not use hardcoded keymaps)
  keymaps = {
    insert = false,
    insert_line = false,

    normal = false,

    normal_cur = false,
    normal_line = false,
    normal_cur_line = false,

    visual = false,
    visual_line = false,

    delete = false,

    change = false,
    change_line = false,
  },
})

require("surround-ui").setup({ root_key = "s" })

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
    disable = { "latex" }, -- Vimtex promises better highlighting
  },
})

require("stay-centered").setup()

require("hlargs").setup()

-- Auto start markdown preview, and change the preview when I change buffers.
g.mkdp_auto_start = 1
g.mkdp_auto_close = 0
g.mkdp_combine_preview = 1

-- Opens markdown preview in a new Firefox window
vim.cmd([[
        function OpenMarkdownPreview(url)
          execute "silent ! firefox --new-window " . a:url
        endfunction
      ]])

vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
