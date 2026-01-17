vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#e55c7a" })
group = vim.api.nvim_create_augroup("ShowTrailingWhitespace", {})

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWinEnter" }, {
  pattern = "*",
  group = group,
  callback = function()
    -- buftype logic prevents weird windows like completions from getting
    -- trailing whitespace highlighting.
    if vim.bo.buftype == "" then
      vim.cmd([[match TrailingWhitespace /\s\+$/]])
    end
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = group,
  -- Only shows trailing whitespace on OTHER lines, not the line you're
  -- currently typing on. Thanks, vimwiki!
  command = [[match trailingWhitespace /\s\+\%#\@<!$/]],
})
