local ls = require("luasnip")

ls.config.set_config()

-- imap bindings are done in blink.cmp
vim.cmd([[
  smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
  smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]])

-- require("luasnip.loaders.from_lua").load({ paths = { "~/Documents/projects/snippets" } })
