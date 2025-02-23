local cmp = require("cmp")
local cmpmap = cmp.mapping

-- Flip between, but don't preview. Only fill in on enter
local selectBehavior = { behavior = cmp.SelectBehavior.Select }

require("cmp").setup({


  -- Disable completions while in a comment
  enabled = function()
    local context = require("cmp.config.context")
    if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
      return false
    end

    return true
  end,

  snippet =
  {
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },

  mapping =
  {
    -- Select is false, so you have to actually press tab to choose a completion
    ["<Enter>"] = cmpmap.confirm({ select = false }),

    ["<S-Tab>"] = cmpmap.select_prev_item(selectBehavior),
    ["<Tab>"] = cmpmap.select_next_item(selectBehavior);
  },

  sources =
  {
    { name = "nvim_lsp" },
  },

})
