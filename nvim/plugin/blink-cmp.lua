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
    list = {
      selection = {
        preselect = true,
        -- Ghost text is preferable
        auto_insert = false,
      },
    },

    ghost_text = {
      enabled = true,
    },

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

            highlight = function(ctx)
              return colorful_menu.blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
  },

  sources = {
    -- Prioritizes snippets higher - not the actual snippets, but the LSP snippets.
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

    -- Removing buffer completion from the defaults
    default = {
      "lsp",
      "path",
      "snippets",
      "omni", -- For vimtex
    },
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },

    -- Loading lazydev through blink leads to better signature help and overall
    -- a better experience
    providers = {

      snippets = {
        opts = {
          show_autosnippets = false,
        },
      },

      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },

  -- Signature hints - this is super great, enough that I prefer it to
  -- lsp_signature, my previous solution
  signature = {
    enabled = true,

    window = {
      show_documentation = true,
    },
  },

  cmdline = {
    enabled = true,

    completion = {
      list = {
        selection = {
          -- In cmdline, you should press tab to select something, and then
          -- enter. Better than having it autoselect the first one, and no way
          -- to just press enter with what you've got
          preselect = false,
        },
      },

      menu = {
        auto_show = true,
      },
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
