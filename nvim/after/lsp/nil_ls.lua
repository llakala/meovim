---@type vim.lsp.Config
return {
  on_attach = function(client)
    -- We get completion from nixd, and everything else from nil
    client.server_capabilities.completionProvider = nil
  end,
}
