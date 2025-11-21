vim.keymap.set({ "n", "x" }, "y", function()
  vim.b.cursor_pre_yank = vim.api.nvim_win_get_cursor(0)
  return "y"
end, { expr = true })
vim.keymap.set("n", "Y", function()
  vim.b.cursor_pre_yank = vim.api.nvim_win_get_cursor(0)
  return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking, and keep cursor in the same place",
  callback = function()
    vim.hl.on_yank()
    if vim.v.event.operator == "y" and vim.b.cursor_pre_yank ~= nil then
      vim.api.nvim_win_set_cursor(0, vim.b.cursor_pre_yank)
      vim.b.cursor_pre_yank = nil
    end
  end,
  group = vim.api.nvim_create_augroup("YankLogic", { clear = true }),
})
