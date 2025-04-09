cmp = require("blink.cmp")
lsp_capabilities = cmp.get_lsp_capabilities()

local colorful_menu = require("colorful-menu")

cmp.setup({
  -- See comment on above function
  keymap = {
    preset = "enter",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },

  completion = {
    ghost_text = {
      enabled = true,
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },

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

  -- Removing buffer completion from the defaults
  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
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
      menu = {
        auto_show = true,
      },
    },
  },

  -- Prioritizes exact matches higher
  fuzzy = {
    sorts = {
      "exact",
      -- defaults
      "score",
      "sort_text",
    },
  },
})
