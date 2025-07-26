vim.diagnostic.config({ virtual_text = false })

require("tiny-inline-diagnostic").setup({
  options = {
    -- Will show other diagnostics, even when they're not on the current line
    -- Way better than the neovim 0.11 implementation, since you can't see the
    -- diagnostic when not on the same line. This is a tiny bit janky since it
    -- shows ^@ where there would be newlines in a message, but it's far better
    -- than the status quo!
    multilines = {
      enabled = true,

      -- Without this, a line with multiple errors seems to only show one of the
      -- errors
      always_show = true
    }
  }
})
