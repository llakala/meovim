local ls = require("luasnip")

ls.setup({
  enable_autosnippets = true,
  snip_env = {
    parse = ls.parser.parse_snippet,

    autoparse = function(trig, body, opts)
      trig = {
        snippetType = "autosnippet",
        trig = trig,
      }

      return ls.parser.parse_snippet(trig, body, opts)
    end,
  },
})

-- imap bindings are done in blink.cmp
vim.cmd([[
  smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
  smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]])

-- require("luasnip.loaders.from_lua").load({ paths = { "~/Documents/projects/snippets" } })
