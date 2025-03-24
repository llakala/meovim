Snacks = require("snacks")

Snacks.setup({
  quickfile = { enabled = true },
  input = { enabled = true }, -- Doesn't replace all input, but will work for stuff like lsp renames
  picker = {
    enabled = true,
    focus = "list", -- Start in normal mode
    ui_select = true,
  },
})

vim.ui.input = "Snacks.input"
vim.ui.select = "Snacks.picker.select"
