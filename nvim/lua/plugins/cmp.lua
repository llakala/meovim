local cmp = require("cmp")
local cmpmap = cmp.mapping

require("cmp_git").setup({})


-- Flip between, but don't preview. Only fill in on enter
local selectBehavior = { behavior = cmp.SelectBehavior.Select }

cmp.setup({

  completion =
  {
    completeopt = "menu,menuone,noinsert"
  },


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

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "async_path" },
    { name = "git" },
    { name = 'nvim_lsp_signature_help' },
    {
      name = 'lazydev',
      -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      group_index = 0,
    },
    -- Disabling for now until I can stop words in comments from being added
    -- {
    --   name = "buffer",
    --   keyword_length = 1
    -- },
  })
})
