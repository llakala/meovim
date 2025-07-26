require("mini.comment").setup({
  mappings = {
    comment = "",
    comment_line = "#",
    comment_visual = "#",

    -- We've homerolled a cooler comment textobject that gives separate behavior
    -- with `ic` vs `ac`, and alsp handles EOL comments! Check it out here:
    -- https://github.com/llakala/meovim/blob/main/nvim/plugin/mini/ai.lua
    textobject = "",
  },
})

vim.keymap.del("o", "gc")
vim.keymap.del("n", "gcc")
