-- We use this instead of `vim.o.scrolloff`, because this keeps the cursor
-- centered at the end of the file. We prefer this over external plugins like
-- ``keep-centered.nvim` or `scrollEOF.nvim`, as both have slight annoyances in
-- my experience.
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  desc = "Center cursor",
  command = "normal! zz",
})
