-- No, that's not a typo, the string has setup in it
require("rainbow-delimiters.setup").setup({
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterViolet",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
  },
})

-- Enable synchronous treesitter parsing to prevent flashing
vim.g._ts_force_sync_parsing = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.treesitter.language._complete(),
  callback = function()
    vim.treesitter.start()
  end,
})
