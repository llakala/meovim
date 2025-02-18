local cmp = require("cmp")
local cmpmap = cmp.mapping

-- Flip between, but don't preview. Only fill in on enter
local selectBehavior = { behavior = cmp.SelectBehavior.Select }

require("cmp").setup({
  snippet =
  {
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },

  mapping =
  {
    -- Accept ([y]es) the completion.
    --  This will auto-import if your LSP supports it.
    --  This will expand snippets if the LSP sent a snippet.
    ["<Enter>"] = cmpmap.confirm({ select = true }),

    ["<S-Tab>"] = cmpmap.select_prev_item(selectBehavior),
    ["<Tab>"] = cmpmap.select_next_item(selectBehavior);
  },

  sources =
  {
    { name = "nvim_lsp" },
  },

})
