require("mini.trailspace").setup({
  only_in_normal_buffers = true, -- Setting this to false doesn't work in Insert mode, and it breaks Yazi
})

vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#e55c7a" }) -- Git's "red reverse"

require("mini.surround").setup({
  mappings = {
    add = "ms", -- Add surrounding in Normal and Visual modes
    delete = "md", -- Delete surrounding
    replace = "mr", -- Replace surrounding
  },
})

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

vim.keymap.set("n", "ms", [[v:lua MiniSurround.add('visual')<CR>]], { silent = true })
