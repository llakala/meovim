o.tabstop = 2
o.shiftwidth = 2

require("lazydev").setup({})
require("nvim-surround").buffer_setup({
  surrounds = {
    -- See https://github.com/svitax/nvim/blob/17a81a1c5be9a571c3b278d25a9fa585881a79e5/lua/plugins/surround.lua#L41
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
