return {
  settings = {
    Lua = {
      hint = {
        enable = true,
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
        -- Neovim and Yazi globals
        globals = { "vim", "require", "ya", "cx", "Command" },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- https://github.com/nvim-lua/kickstart.nvim/issues/543#issuecomment-1859319206
        disable = { "missing-fields", "lowercase-global" },
      },
    },
  },
}
