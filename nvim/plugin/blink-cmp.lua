cmp = require("blink.cmp")
lsp_capabilities = cmp.get_lsp_capabilities()

vim.lsp.config("*", {
  capabilities = lsp_capabilities,
})

local colorful_menu = require("colorful-menu")

cmp.setup({
  keymap = {
    preset = "enter",

    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
  },

  snippets = { preset = "luasnip" },

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

  sources = {
    -- Prioritizes snippets higher
    -- Thanks to https://github.com/wlh320/wlh-dotfiles/blob/aa9be6ffbe587452a42520626befc10ed5a614b8/config/nvim/init.lua#L349-L356
    -- for being a wonderful example of how to do something like this
    transform_items = function(_, items)
      for _, item in ipairs(items) do
        if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
          item.score_offset = item.score_offset + 10
        end
      end
      return items
    end,

    -- Removing buffer completion from the defaults, and adding omni for vimtex
    default = {
      "lsp",
      "path",
      "snippets",
      "omni",
    },
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },

    providers = {
      -- autosnippets are automatically expanded, so showing the completion
      -- would be a waste of time
      snippets = { opts = { show_autosnippets = false } },

      -- Loading lazydev through blink leads to better completion in a few areas
      -- like require statements
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },

  signature = {
    enabled = true,

    window = { show_documentation = true },
  },

  cmdline = {
    enabled = true,

    completion = {
      -- In cmdline, you should press tab to select something, and then
      -- enter. Better than having it autoselect the first one, and no way
      -- to just press enter with what you've got
      list = {
        selection = {
          preselect = false,
        },
      },

      menu = { auto_show = true },
    },
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
})
