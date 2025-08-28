cmp = require("blink.cmp")
lsp_capabilities = cmp.get_lsp_capabilities()

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
vim.keymap.set("c", "<A-k>", "<Up>")
vim.keymap.set("c", "<A-j>", "<Down>")

cmp.setup({
  keymap = {
    -- Want to make something that I can fully control and understand!
    preset = "none",

    ["<C-space>"] = { "show", "hide" },
    ["<C-s>"] = { "show_signature", "hide_signature" },

    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },

    -- The idea is to do <C-l> when you're doing a lot of picking, and <CR> when
    -- you're typing.
    ["<C-l>"] = { "accept", "fallback" },
    ["<CR>"] = { "accept", "fallback" },

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

  snippets = { preset = "luasnip" },

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
})
