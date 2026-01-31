local ls = require("luasnip")

-- From https://github.com/L3MON4D3/LuaSnip/issues/656#issuecomment-1313310146
vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", {}),
  pattern = { "s:n", "i:*" },
  desc = "Forget the current snippet when leaving insert mode",
  callback = function(evt)
    if ls.session and ls.session.current_nodes[evt.buf] and not ls.session.jump_active then
      ls.unlink_current()
    end
  end,
})

ls.setup({
  enable_autosnippets = true,
  snip_env = {
    in_ts_group = Custom.in_ts_group,
  },
})

require("luasnip.loaders.from_lua").lazy_load({
  lazy_paths = { "/home/emanresu/Documents/projects/meovim/nvim/snippets/" },
})
