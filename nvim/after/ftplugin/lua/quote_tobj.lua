-- From https://github.com/echasnovski/nvim/blob/9d9b6c057aa6f4731efd4e5df3ecf350bdba6730/after/ftplugin/lua.lua#L10
vim.b.miniai_config = {
  custom_textobjects = {
    ["Q"] = { "%[%[().-()%]%]" },
  },
}

-- See https://github.com/svitax/nvim/blob/17a81a1c5be9a571c3b278d25a9fa585881a79e5/lua/plugins/surround.lua#L41
require("nvim-surround").buffer_setup({
  surrounds = {
    ["Q"] = {
      find = "%[%[.-%]%]",
      add = { "[[", "]]" },
      delete = "(%[%[)().-(%]%])()",
      change = {
        target = "(%[%[)().-(%]%])()",
      },
    },
  },
})
