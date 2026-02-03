local blink = require("blink.cmp")
local types = require("blink.cmp.types")
lsp_capabilities = blink.get_lsp_capabilities()

vim.lsp.config("*", {
  capabilities = lsp_capabilities,
})

local colorful_menu = require("colorful-menu")

-- Acts as enter for cmdline, even if a completion isn't currently on
vim.keymap.set("c", "<C-l>", "<CR>")

-- We use ctrl-j and ctrl-k instead, and if we don't unbind these, they'll
-- trigger the default completions.
vim.keymap.set("c", "<Tab>", "<Nop>")
vim.keymap.set("c", "<S-Tab>", "<Nop>")

-- Move through cmdline history
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("c", "<C-n>", "<Down>")
vim.keymap.set("c", "<Up>", "<Nop>")
vim.keymap.set("c", "<Down>", "<Nop>")

blink.setup({
  keymap = {
    -- Want to make something that I can fully control and understand!
    preset = "none",

    ["<C-space>"] = { "show", "hide" },

    -- Toggle between only showing snippets, and showing all providers. We can't
    -- just enable the `snippets` module, since that's only luasnip stuff. We
    -- use a custom provider `lsp_snippets` that filters the lsp provider for
    -- only snippets.
    ["<C-s>"] = {
      function()
        local context = blink.get_context()
        if context == nil then
          return
        end
        local current_providers = context.providers
        local snippet_providers = { "snippets", "lazydev", "lsp_snippets" }

        -- Toggle between previous set of providers and snippet providers.
        -- we need vim.inspect since `==` checks identity, not value. Yes, Lua
        -- is pulling a Java on us.
        if vim.inspect(current_providers) ~= vim.inspect(snippet_providers) then
          vim.g.prev_providers = current_providers
          blink.show({ providers = snippet_providers })
        else
          blink.show({ providers = vim.g.prev_providers })
          vim.g.prev_providers = {}
        end
      end,
    },

    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },

    -- Use <C-l> when picking, and <CR> when typing
    ["<C-l>"] = { "accept", "fallback" },
    ["<CR>"] = { "accept", "fallback" },

    -- TODO: consider using something other than <Tab>, see
    -- https://github.com/L3MON4D3/LuaSnip/issues/953
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },

  completion = {
    -- Autoselect the first element, but don't insert it. Instead, just preview
    -- the insert with ghost text.
    list = {
      selection = {
        preselect = true,
        -- Ghost text is preferable
        auto_insert = false,
      },
    },
    ghost_text = { enabled = true },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },

    -- I'd prefer to have this through nvim-autopairs, but I couldn't get it
    -- working. See https://github.com/windwp/nvim-autopairs/issues/477
    accept = {
      auto_brackets = {
        enabled = true,

        -- Pipe operators there - no need
        blocked_filetypes = { "gleam" },
      },
    },

    menu = {
      draw = {
        columns = { { "kind_icon" }, { "label", "label_description" } },

        components = {
          label = {
            -- Removes label_details from being added to label by default
            -- See https://github.com/Saghen/blink.cmp/issues/843
            text = function(ctx)
              return ctx.label
            end,

            -- colorize each completion type
            highlight = colorful_menu.blink_components_highlight,
          },
        },
      },
    },
  },

  cmdline = {
    enabled = true,
    keymap = {
      preset = "none",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },

    completion = {
      -- In cmdline, we want to manually select something - and once it's
      -- selected, we can keep scrolling
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },

      menu = { auto_show = true },
    },
  },

  snippets = {
    preset = "luasnip",
    -- From https://github.com/BirdeeHub/nixCats-nvim/blob/c6000fb730d4067e3e1d65e9d5a2cbcd1ceaef83/templates/example/lua/myLuaConf/plugins/completion.lua#L104
    -- Prevents snippet placeholders from staying when you leave insert mode
    active = function()
      local ls = require("luasnip")
      if ls.in_snippet() and not blink.is_visible() then
        return true
      elseif not ls.in_snippet() and vim.fn.mode() == "n" then
        ls.unlink_current()
      end
      return false
    end,
  },

  signature = {
    enabled = true,

    window = { show_documentation = true },
  },

  -- Prioritizes exact matches higher
  fuzzy = {
    implementation = "prefer_rust_with_warning",

    sorts = {
      "exact",
      -- defaults
      "score",
      "sort_text",
    },
  },

  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "omni" },
    per_filetype = {
      nix = { "lazydev", "lsp_no_keywords", "path", "snippets", "omni" },
    },
    providers = {
      -- autosnippets are automatically expanded, so showing the completion
      -- would be a waste of time
      snippets = { opts = { show_autosnippets = false } },

      -- Filtered version of `lsp` that only contains snippets. We do this so we
      -- can only see snippets when pressing Ctrl+s
      lsp_snippets = {
        name = "LSP Snippets",
        module = "blink.cmp.sources.lsp",
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind == types.CompletionItemKind.Snippet
          end, items)
        end,
      },

      lsp_no_keywords = {
        name = "LSP without keywords",
        module = "blink.cmp.sources.lsp",
        transform_items = function(_, items)
          -- the default transformer will do this
          return vim.tbl_filter(function(item)
            return item.kind ~= types.CompletionItemKind.Keyword
          end, items)
        end,
      },

      -- Loading lazydev through blink leads to better completion in a few areas
      -- like require statements
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})
