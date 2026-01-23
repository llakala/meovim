Snacks = require("snacks")

require("snacks").setup({
  quickfile = { enabled = true },

  -- Doesn't replace all input, but will work for stuff like lsp renames
  input = {
    enabled = true,
    win = {
      on_win = function()
        -- See https://github.com/folke/snacks.nvim/issues/2198
        vim.schedule(function()
          vim.cmd("stopinsert")
          vim.cmd("norm ^")
        end)
      end,
    },
  },

  -- Display indent lines, like `indent-blankline`
  indent = {
    enabled = true,

    -- We use `mini.indentscope` for displaying the current scope, since it's
    -- more customizable and doesn't trigger on empty whitespace
    scope = { enabled = false },
  },
})
