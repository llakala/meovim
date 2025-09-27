local regex = "^\\s*=\\+"

vim.keymap.set({ "n", "o" }, "]]", function()
  vim.fn.search(regex, "W")
end, { buffer = true })

vim.keymap.set({ "n", "o" }, "[[", function()
  vim.fn.search(regex, "Wb")
end, { buffer = true })
