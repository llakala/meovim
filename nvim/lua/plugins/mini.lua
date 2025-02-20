require("mini.trailspace").setup({
  only_in_normal_buffers = true, -- Setting this to false doesn't work in Insert mode, and it breaks Yazi
})

vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#e55c7a"} ) -- Git's "red reverse"

require("mini.cursorword").setup({
  delay = 10,
})

require("mini.move").setup()

require("mini.surround").setup({
  mappings = {
    add = "ms", -- Add surrounding in Normal and Visual modes
    delete = "md", -- Delete surrounding
    replace = "mr", -- Replace surrounding
  }
})

vim.keymap.set('n', 'ms', [[v:lua MiniSurround.add('visual')<CR>]], { silent = true })
