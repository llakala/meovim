vim.api.nvim_create_user_command("Rm", function(ctx)
  local file = vim.fn.expand("%")

  if vim.o.modified then
    if ctx.bang then
      vim.cmd.write()
    else
      vim.api.nvim_echo({ { "E37: No write since last change (add ! to override)" } }, false, { err = true })
      return
    end
  end

  vim.fn.delete(file)
  vim.cmd.bdelete(file)
end, { bang = true })

vim.cmd.cabbrev("rm", "Rm")
