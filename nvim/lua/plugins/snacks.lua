require("snacks").setup({
  quickfile = { enabled = true },
  input = { enabled = true }, -- Doesn't replace all input, but will work for stuff like lsp renames
})

vim.ui.input = "Snacks.input"
