return {
  "helpview.nvim",
  after = function()
    require("helpview").setup({
      -- Keep previewing in visual mode
      preview = {
        modes = { "n", "c", "v", "no" },
      },
    })
  end,
  ft = "help",
}
