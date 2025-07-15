require("mini.jump").setup({
  delay = {
    highlight = 0,
  },
})

-- Press escape to stop jumping and clear highlights
local jump_stop = function()
  vim.cmd.nohlsearch()

  if not MiniJump.state.jumping then
    return "<Esc>"
  end
  MiniJump.stop_jumping()
end

-- remap for normal, visual, and operator mode
anoremap("<Esc>", jump_stop, { expr = true, desc = "Stop jumping and clear highlights" })
