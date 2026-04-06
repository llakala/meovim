local group = vim.api.nvim_create_augroup("OpenQuickfixAutomaticalyy", {})

vim.api.nvim_create_autocmd("QuickFixCmdPre", {
  buffer = 0,
  group = group,
  callback = function()
    vim.api.nvim_create_autocmd("WinClosed", {
      once = true,
      command = "copen",
    })
  end,
})
