o.tabstop = 4
o.shiftwidth = 4

require("jdtls").start_or_attach({
  cmd = { "jdtls" },
  capabilities = lsp_capabilities,

  settings = {
    -- make sure things are under `settings.java`, or things just
    -- won't apply and you'll have no clue why!
    java = {
      signatureHelp = {
        enabled = true,
        description = {
          enabled = true,
        },
      },

      inlayHints = {
        parameterNames = {
          enabled = "none", -- jdtls inlay hints are pretty useless
        },
      },
    },
  },
})
