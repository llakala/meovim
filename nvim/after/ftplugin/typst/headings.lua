local regex = "^=\\+"

-- Jump between headers in Typst. There isn't much precedence for what to do
-- with the beginning/end of the buffer when there aren't any matches - so I
-- copied the behavior of python, where `]]` will take you to the beginning of
-- the last line if there aren't any matches, and `[[` will only take you to the
-- beginning of the first line if you're already there. Quite strange behavior,
-- but I'll obey.
vim.keymap.set({ "n", "o", "x" }, "]]", function()
  if vim.fn.search(regex, "W") == 0 then
    vim.cmd("norm! G^")
  end
end, { buffer = true })

vim.keymap.set({ "n", "o", "x" }, "[[", function()
  if vim.fn.line(".") == 1 then
    vim.cmd("norm! ^")
  end
  vim.fn.search(regex, "Wb")
end, { buffer = true })
