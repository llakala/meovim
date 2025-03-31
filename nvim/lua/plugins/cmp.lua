local cmp = require("cmp")
local cmpmap = cmp.mapping

require("cmp_git").setup({
  trigger_actions = {
    {
      debug_name = "git_commits",

      -- Changed from the default `:` to not trigger with conventional commits
      trigger_character = "$",

      action = function(sources, trigger_char, callback, params, _)
        return sources.git:get_commits(callback, params, trigger_char)
      end,
    },
    {
      debug_name = "github_issues_and_pr",
      trigger_character = "#",
      action = function(sources, trigger_char, callback, _, git_info)
        return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
      end,
    },
    {
      debug_name = "github_mentions",
      trigger_character = "@",
      action = function(sources, trigger_char, callback, _, git_info)
        return sources.github:get_mentions(callback, git_info, trigger_char)
      end,
    },
  },
})

-- Flip between, but don't preview. Only fill in on enter
local selectBehavior = { behavior = cmp.SelectBehavior.Select }

cmp.setup({

  -- Disable completions while in a comment
  enabled = function()
    local context = require("cmp.config.context")
    if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
      return false
    end

    return true
  end,

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  completion = {
    completeopt = "menu,menuone,noinsert",
  },

  matching = {
    disallow_fuzzy_matching = true,
  },

  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },

  mapping = {
    -- Select is false, so you have to actually press tab to choose a completion
    ["<Enter>"] = cmpmap.confirm({ select = false }),

    ["<S-Tab>"] = cmpmap.select_prev_item(selectBehavior),
    ["<Tab>"] = cmpmap.select_next_item(selectBehavior),
  },

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "async_path" },
    { name = "git" },
    {
      name = "lazydev",
      -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      group_index = 0,
    },

    -- Disabling for now until I can stop words in comments from being added
    -- {
    --   name = "buffer",
    --   keyword_length = 1
    -- },
  }),
})

-- Better live signature popups
require("lsp_signature").setup({
  -- Don't show docs, just the signature
  -- You can see the docs with lsp `vim.lsp.buf.hover()`
  doc_lines = 0,

  hint_enable = false,
})
