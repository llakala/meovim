local cmpmap = require("cmp").mapping
require("cmp").setup({
    snippet = {
        -- Exclusive to LuaSnip, check nvim-cmp documentation for usage with a different snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    mapping = {
          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ["<Enter>"] = cmpmap.confirm({ select = true }),

          ["<S-Tab>"] = cmpmap.select_prev_item(),
          ["<Tab>"] = cmpmap.select_next_item(),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})
