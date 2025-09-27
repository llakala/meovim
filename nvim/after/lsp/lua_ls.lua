---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      hint = {
        enable = true,
        paramName = "Literal",
        arrayIndex = "Disable",
      },

      -- Note that lazydev doesn't follow this by default - I point to a fork.
      -- See https://github.com/folke/lazydev.nvim/pull/113
      workspace = {
        ignoreDir = {
          ".direnv",
        },
      },

      diagnostics = {
        globals = { "ya", "cx", "Command" }, -- Yazi globals
        disable = { "missing-fields", "lowercase-global" },
      },
    },
  },
}
