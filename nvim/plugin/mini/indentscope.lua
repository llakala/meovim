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

-- Custom binding that operates on the lines starting/ending an indentation level
vim.keymap.set("o", "si", Custom.operate_on_surrounding_indent)
