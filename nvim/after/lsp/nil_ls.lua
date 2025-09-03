return {
  on_attach = function(client)
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.renameProvider = nil
  end,
}
