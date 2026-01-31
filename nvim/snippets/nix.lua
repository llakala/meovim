local not_in_comment = function()
  local _, row, col, _ = unpack(vim.fn.getpos("."))
  local node = vim.treesitter.get_node({
    pos = { row - 1, col - 2 },
  })
  return node and node:type() ~= "comment"
end

return {
  s({
    trig = "let",
    show_condition = not_in_comment,
  }, fmt("let\n  {}\nin ", { i(1) }), {}),
}
