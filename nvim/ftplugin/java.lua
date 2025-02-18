vim.o.tabstop = 4
vim.o.shiftwidth = 4

require("jdtls").start_or_attach({
  cmd = { "jdtls" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  settings =
  {
    inlayHints =
    {
      parameterNames =
      {
        enabled = "all", -- Would disable, but it doesn't seem to work and I'd like it to, so leaving it on for debugging
      }
    }
  }
})
