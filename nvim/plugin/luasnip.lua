local ls = require("luasnip")

local group_name = "LuasnipSignGroup"
local group = vim.api.nvim_create_augroup(group_name, {})
vim.fn.sign_define("LuasnipNodeLocation", {
  text = "",
  texthl = "DiagnosticOk",
})

-- Put indicator on the line of the current snippet node. Good way of seeing
-- if you're still within a snippet and don't realize it
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "LuasnipInsertNodeEnter", "LuasnipChoiceNodeEnter" },
  callback = function(a)
    local node = ls.session.event_node
    vim.fn.sign_place(0, group_name, "LuasnipNodeLocation", a.buf, {
      lnum = node:get_buf_position()[1] + 1,
      priority = 13,
    })
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { "LuasnipInsertNodeLeave", "LuasnipChoiceNodeLeave" },
  callback = function(a)
    vim.fn.sign_unplace(group_name, {
      buffer = a.buf,
    })
  end,
})

ls.setup({
  enable_autosnippets = true,
  snip_env = {
    in_ts_group = Custom.in_ts_group,
  },
})

require("luasnip.loaders.from_lua").load({ paths = { "/home/emanresu/Documents/projects/meovim/nvim/snippets/" } })
