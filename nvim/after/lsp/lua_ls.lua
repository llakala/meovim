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
        -- Yazi and Neovim globals, for before lazydev loads in
        globals = { "vim", "require", "ya", "cx", "Command" },

        disable = { "missing-fields", "lowercase-global" },
      },
    },
  },
}
