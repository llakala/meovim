o.wrap = true

require("render-markdown").setup({
  completions = { lsp = { enabled = true } },

  render_modes = true,

  anti_conceal = {
    enabled = true,
  },

  code = {
    sign = true,
    width = "block",
    min_width = 45,
  },

  heading = {
    icons = {},
    border = true,
  },

  latex = {
    enabled = false,
  },

  pipe_table = { preset = "heavy" },
})
