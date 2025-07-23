vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#e55c7a" })

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd([[match TrailingWhitespace /\s\+$/]])
    end
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = [[call clearmatches()]],
})
