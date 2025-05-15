return {
  "which-key.nvim",
  after = function()
    require("which-key").setup({
      preset = "modern",
    })
  end,
}
