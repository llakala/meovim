require("mini.trailspace").setup({
  only_in_normal_buffers = true, -- Setting this to false doesn't work in Insert mode, and it breaks Yazi
})

vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#e55c7a" }) -- Git's "red reverse"

local isc = require("mini.indentscope")
isc.setup({
  options = {
    -- Don't care about the cursor's position within the line
    indent_at_cursor = false,

    -- This is nice in theory, but I find that it causes issues where I'm on a
    -- border when I don't want to be.
    try_as_border = false,
  },

  draw = {
    delay = 0,
    animation = isc.gen_animation.none(),
  },
  symbol = "│",
})

-- Don't populate which-key
require("which-key").add({
  { "ai", mode = "o", hidden = true },
  { "ii", mode = "o", hidden = true },
})

require("mini.move").setup()

vim.keymap.del("n", "gcc")

require("mini.comment").setup({
  mappings = {
    comment = "",
    comment_line = "#",
    comment_visual = "#",

    -- We've homerolled a cooler comment textobject that gives separate behavior
    -- with `ic` vs `ac`, and alsp handles EOL comments! Check it out here:
    -- https://github.com/llakala/meovim/blob/main/nvim/lua/lazy/mini-ai.lua
    textobject = "",
  },
})

vim.keymap.del("o", "gc")
