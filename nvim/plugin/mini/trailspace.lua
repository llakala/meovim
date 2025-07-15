require("mini.trailspace").setup({
  only_in_normal_buffers = true, -- Setting this to false doesn't work in Insert mode, and it breaks Yazi
})

vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#e55c7a" }) -- Git's "red reverse"
