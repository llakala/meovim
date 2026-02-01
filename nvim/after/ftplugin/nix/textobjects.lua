local nvim_surround = require("nvim-surround")
local utils = require("nvim-surround.config")
-- See https://github.com/kylechui/config.nvim/blob/22a3a13f348aaa49ddd2a498fb03991936b20464/after/ftplugin/nix.lua
nvim_surround.buffer_setup({
  surrounds = {
    ["$"] = {
      find = "$%b{}",
      add = { "${", "}" },
      delete = "(%${)().-(})()",
    },
    ["Q"] = {
      add = { "''", "''" },
      find = "''.-''",
      -- TODO: see if it's possible to remove newlines
      delete = "^(..)().-(..)()$",
    },
  },
  aliases = {
    q = { '"', "Q" },
  },
})

vim.b.miniai_config = {
  custom_textobjects = {
    ["$"] = { "%${().-()}" },
    Q = { "''().-()''" },

    -- Either "foo" or ''foo''
    q = { { "''().-()''", { '%b""', "^.().*().$" } } },
  },
}
