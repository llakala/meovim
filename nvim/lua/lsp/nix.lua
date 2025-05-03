lspconfig.nixd.setup({
  capabilities = lsp_capabilities,
  cmd = {
    "nixd",
    "--inlay-hints=false",
    "--semantic-tokens=true", -- NEEDED, makes syntax highlighting much better
  },
  -- settings.nixd =
  -- {
  --  nixpkgs.expr = "import <nixpkgs> { }",
  --   options.nixos.expr = "${hostOptions}",
  -- },
})
