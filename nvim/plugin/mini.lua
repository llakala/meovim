require("mini.trailspace").setup({
  only_in_normal_buffers = true, -- Setting this to false doesn't work in Insert mode, and it breaks Yazi
})

vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#e55c7a" }) -- Git's "red reverse"

local isc = require("mini.indentscope")
isc.setup({
  options = {
    -- Change where the line is based on the horizontal position within the line
    indent_at_cursor = true,

    -- Show the indent scope if the next line begins one, to make it
    -- a header more associated with its scope
    try_as_border = true,
  },

  draw = {
    delay = 0,
    animation = isc.gen_animation.none(),
  },
  symbol = "│",
})

vim.keymap.del("n", "gcc")

require("mini.comment").setup({
  mappings = {
    comment = "",
    comment_line = "#",
    comment_visual = "#",

    -- "delete around comment" feels cleaner to me than "delete global comment".
    -- We use around because it doesn't keep the beginning of the comment - we
    -- need to investigate a custom textobject for this.
    textobject = "ac",
  },
})

vim.keymap.del("o", "gc")

-- Don't populate which-key
require("which-key").add({
  { "ai", mode = "o", hidden = true },
  { "ii", mode = "o", hidden = true },

  { "ac", mode = "o", hidden = true },
})
