vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

local tlscp = require("telescope.builtin")

nnoremap("<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Mode independent - will show code actions on selection if
-- in visual mode
nnoremap("<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
vnoremap("<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

nnoremap("<leader>d", function()
  vim.diagnostic.open_float() -- d for diagnostics
end, { desc = "Diagnostic" })

-- i for implementation
nnoremap("<leader>i", function()
  tlscp.lsp_definitions()
end, { desc = "View implementation" })

-- u for usage
nnoremap("<leader>u", function()
  tlscp.lsp_references()
end, { desc = "View usage(s)" })

-- w for workspace. Shows workspace diagnostics, so you can see errors in other
-- files. Great for Gleam dev, since the Gleam LSP gets stuck if one file has errors.
-- Note that this doesn't work for all LSPs!
nnoremap("<leader>w", function()
  tlscp.diagnostics()
end, { desc = "Workspace diagnostics" })
