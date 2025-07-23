vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

nnoremap("<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Mode independent - will show code actions on selection if
-- in visual mode
nnoremap("<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
vnoremap("<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

nnoremap("<leader>d", function()
  vim.diagnostic.open_float() -- d for diagnostics
end, { desc = "Diagnostic" })
