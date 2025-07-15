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
