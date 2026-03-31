-- Edit relative to current file
vim.api.nvim_create_user_command("Enter", function(ctx)
  if #ctx.fargs == 0 then
    vim.cmd.edit("%:p:h/<cfile>")
  end
  vim.cmd.edit("%:p:h/" .. ctx.fargs[1])
end, {
  nargs = "?",
  complete = function()
    local dir = vim.fn.expand("%:p:h")
    local ret = vim.split(vim.fn.glob(dir .. "/*"), "\n")
    for idx, path in pairs(ret) do
      ret[idx] = vim.fn.fnamemodify(path, ":t")
    end
    return ret
  end,
})
