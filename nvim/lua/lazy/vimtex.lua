return {
  "vimtex",
  -- event = "DeferredUIEnter",
  after = function()
    g.vimtex_view_general_viewer = "zathura"
    vim.g.maplocalleader = " "
  end,
}
