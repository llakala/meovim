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

require("lazydev").setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
