lspconfig.lua_ls.setup({
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },

      diagnostics = {
        -- Neovim and Yazi globals
        globals = { "vim", "require", "ya", "cx", "Command" },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- https://github.com/nvim-lua/kickstart.nvim/issues/543#issuecomment-1859319206
        disable = { "missing-fields", "lowercase-global" },
      },
    },
  },
})

require("lazydev").setup({})
