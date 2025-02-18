require("mini.trailspace").setup({
  only_in_normal_buffers = false, -- Not sure if this is working
})

vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#e55c7a"} ) -- Git's "red reverse"

require("mini.cursorword").setup({
  delay = 10,
})

require("mini.move").setup()
