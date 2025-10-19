---@type vim.lsp.Config
return {
  cmd = {
    "nixd",
    "--inlay-hints=false",
    "--semantic-tokens=true", -- NEEDED, makes syntax highlighting much better
  },
  on_attach = function(client)
    -- We disable everything EXCEPT completions and semantic tokens, since I use
    -- both nixd and nil, and nil is better at everything else
    client.server_capabilities.codeActionProvider = nil
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.inlayHintProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.renameProvider = false
  end,

  -- settings.nixd =
  -- {
  --  nixpkgs.expr = "import <nixpkgs> { }",
  --   options.nixos.expr = "${hostOptions}",
  -- },
}
