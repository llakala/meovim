require("mini.jump").setup({
  delay = {
    highlight = 0,
  },
})

-- Press escape to stop jumping and clear highlights + cmdline
local jump_stop = function()
  vim.cmd.nohlsearch()
  vim.cmd.echo()

  if not MiniJump.state.jumping then
    return "<Esc>"
  end
  MiniJump.stop_jumping()
end

-- remap for normal, visual, and operator mode
anoremap("<Esc>", jump_stop, { expr = true, desc = "Stop jumping and clear highlights" })
