-- See https://github.com/kylechui/config.nvim/blob/22a3a13f348aaa49ddd2a498fb03991936b20464/after/ftplugin/nix.lua
require("nvim-surround").buffer_setup({
  surrounds = {
    ["$"] = {
      find = "$%b{}",
      add = { "${", "}" },
      delete = "(%${)().-(})()",
    },
  },
})

vim.b.miniai_config = {
  custom_textobjects = {
    ["$"] = { "%${().-()}" },
  },
}
