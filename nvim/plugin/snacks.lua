Snacks = require("snacks")

require("snacks").setup({
  quickfile = { enabled = true },
  input = { enabled = true }, -- Doesn't replace all input, but will work for stuff like lsp renames

  -- Display indent lines, like `indent-blankline`
  indent = {
    enabled = true,

    -- We use `mini.indentscope` for displaying the current scope, since it's
    -- more customizable and doesn't trigger on empty whitespace
    scope = { enabled = false },
  },
})
