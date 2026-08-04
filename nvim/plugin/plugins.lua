-- No, that's not a typo, the string has setup in it
require("rainbow-delimiters.setup").setup({
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterViolet",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
  },
})

require("globals/dynamic_indent").setup({ pattern = "*.md" })

-- Enable synchronous treesitter parsing to prevent flashing
vim.g._ts_force_sync_parsing = true

local max_lines = 2500
vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.treesitter.language._complete(),
  group = vim.api.nvim_create_augroup("LoadTreesitter", {}),
  callback = function(event)
    if vim.api.nvim_buf_line_count(event.buf) > max_lines then
      return
    end
    vim.treesitter.start()
  end,
})

require("fundo").setup()
