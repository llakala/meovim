vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  float = {
    border = "rounded",
  },
})

-- Replace mode is stupid, and nobody sane would ever use it. If neovim can
-- change K, I can change R.
vim.keymap.del("n", "grn")
nnoremap("R", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- This is just ascii stuff by default - useless to me!
vim.keymap.del({ "n", "x" }, "gra")
vim.keymap.set({ "n", "x" }, "ga", vim.lsp.buf.code_action, { desc = "Code action" })
