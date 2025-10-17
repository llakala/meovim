-- From https://github.com/echasnovski/nvim/blob/9d9b6c057aa6f4731efd4e5df3ecf350bdba6730/after/ftplugin/lua.lua#L10
vim.b.miniai_config = {
  custom_textobjects = {
    ["Q"] = { "%[%[().-()%]%]" },
  },
}
