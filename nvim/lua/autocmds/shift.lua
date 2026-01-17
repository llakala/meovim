vim.keymap.set({ "n", "x" }, "<", function()
  vim.b.cursor_pre_shift = vim.api.nvim_win_get_cursor(0)
  return "<"
end, { expr = true })
vim.keymap.set("n", ">", function()
  vim.b.cursor_pre_shift = vim.api.nvim_win_get_cursor(0)
  return ">"
end, { expr = true })

vim.api.nvim_create_autocmd("TextChanged", {
  desc = "Keep cursor in the same place when shifting text",
  group = vim.api.nvim_create_augroup("KeepCursorPositionOnShift", {}),
  callback = function()
    local pos = vim.b.cursor_pre_shift
    if pos ~= nil then
      local row, col = unpack(pos)
      local shiftwidth = vim.fn.shiftwidth()
      local sign = vim.v.operator == ">" and 1 or -1
      local new_pos = { row, math.max(0, col + (sign * shiftwidth)) }

      vim.api.nvim_win_set_cursor(0, new_pos)
      vim.b.cursor_pre_shift = nil
    end
  end,
  group = vim.api.nvim_create_augroup("ShiftLogic", { clear = true }),
})
