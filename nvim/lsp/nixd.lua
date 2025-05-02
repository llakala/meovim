return {
  cmd = {
    "nixd",
    "--inlay-hints=false",
    "--semantic-tokens=true", -- NEEDED, makes syntax highlighting much better
  },

  -- Copied in from lspconfig - the default support from `vim.lsp` seems to be
  -- missing some nixd support
  filetypes = { "nix" },
  root_markers = { "flake.nix", "git" },

  -- settings.nixd =
  -- {
  --  nixpkgs.expr = "import <nixpkgs> { }",
  --   options.nixos.expr = "${hostOptions}",
  -- },
}
