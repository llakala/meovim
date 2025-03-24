lspconfig.pylsp.setup({
  capabilities = lsp_capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = true },
      },
    },
  },
})
