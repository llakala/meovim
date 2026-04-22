local M = {}
local cache = {}

-- Custom version of > and < that keeps the cursor on the same line before/after
-- shifting. Works with dot repeat by reimplementing the operators in lua
vim.keymap.set("n", ">", function()
  return M.operator(">")
end, { expr = true })
vim.keymap.set("n", "<", function()
  return M.operator("<")
end, { expr = true })

vim.keymap.set("n", ">>", ">>")
vim.keymap.set("n", "<<", "<<")

-- This function only triggers if we're not dot repeating. If we are, the op
-- and pos are reused
M.operator = function(op)
  cache = { op = op, pos = vim.api.nvim_win_get_cursor(0) }
  vim.go.operatorfunc = "v:lua.require'custom.shift'.operator_callback"
  return "g@"
end

M.operator_callback = function()
  local shiftwidth = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
  local sign = cache.op == ">" and 1 or -1
  local first_line = vim.api.nvim_buf_get_mark(0, "[")[1] - 1
  local last_line = vim.api.nvim_buf_get_mark(0, "]")[1]

  -- reimplementation of the shift operator, so we don't have to call it and set
  -- the dot repeat operator
  local lines = vim.api.nvim_buf_get_lines(0, first_line, last_line, true)
  for i, line in ipairs(lines) do
    local _, current_indent = vim.text.indent(0, line)
    lines[i] = vim.text.indent(current_indent + shiftwidth * sign, line, { expandtab = 1 })
  end
  vim.api.nvim_buf_set_lines(0, first_line, last_line, true, lines)

  vim.api.nvim_win_set_cursor(0, cache.pos)
end

return M
