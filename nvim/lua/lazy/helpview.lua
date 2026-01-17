---@module "lz.n"
---@type lz.n.PluginSpec
return {
  "helpview-nvim",
  ft = "help",
  after = function()
    require("helpview").setup({
      preview = {
        modes = { "n", "c", "v", "no" }, -- Keep previewing in visual mode
      },
    })
  end,
}
