vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)

require("lspconfig").nixd.setup({
  cmd =
  {
    "nixd",
    "--inlay-hints=false",
    "-semantic-tokens=true" -- NEEDED, makes syntax highlighting much better
  },
  -- settings.nixd =
  -- {
  --  nixpkgs.expr = "import <nixpkgs> { }",
  --   options.nixos.expr = "${hostOptions}",
  -- },
})

require("lspconfig").fish_lsp.setup {}
