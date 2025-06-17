require("gitsigns").setup()

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

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "latex" }, -- Vimtex promises better highlighting
  },
})

require("stay-centered").setup()

require("hlargs").setup()

-- Don't autostart markdown preview, However, once it is open, if we change
-- buffers, open the markdown file in the same file.
g.mkdp_auto_start = 0
g.mkdp_auto_close = 0
g.mkdp_combine_preview = 1

-- Opens markdown preview in a new Firefox window
vim.cmd([[
        function OpenMarkdownPreview(url)
          execute "silent ! firefox --new-window " . a:url
        endfunction
      ]])

vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
