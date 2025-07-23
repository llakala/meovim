local tlscp = require("telescope.builtin")

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
