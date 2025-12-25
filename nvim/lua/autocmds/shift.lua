vim.keymap.set({ "n", "x" }, "<", function()
  vim.b.cursor_pre_shift = vim.api.nvim_win_get_cursor(0)
  return "<"
end, { expr = true })
vim.keymap.set("n", ">", function()
  vim.b.cursor_pre_shift = vim.api.nvim_win_get_cursor(0)
  return ">"
end, { expr = true })

-- To move the cursor after <$motion or >$motion, our best bet is to use
-- TextChanged, since there isn't some kind of OperatorPerformed textobject.
-- Most of the time, querying `v:operator` lets us check if we've actually just
-- shifted. The only exception I've found so far is undoing - so we prevent the
-- condition from triggering here.
--
-- In the future, I'd like to find a better way of doing this than TextChanged -
-- maybe it's possible to wrap the </> binds.
vim.keymap.set("n", "u", function()
  vim.b.cursor_pre_shift = nil
  return "u"
end, { expr = true })

vim.api.nvim_create_autocmd("TextChanged", {
  desc = "Keep cursor in the same place when shifting text",
  callback = function()
    local operator = vim.v.operator
    local pos = vim.b.cursor_pre_shift
    if (operator == ">" or operator == "<") and pos ~= nil then
      local row, col = unpack(pos)
      local shiftwidth = vim.fn.shiftwidth()
      local sign = operator == ">" and 1 or -1
      local new_pos = { row, col + (sign * shiftwidth) }
      vim.api.nvim_win_set_cursor(0, new_pos)
    end
  end,
  group = vim.api.nvim_create_augroup("ShiftLogic", { clear = true }),
})
