bufmap("<leader>tf", "<plug>(vimtex-cmd-toggle-frac)", "Fraction")
bufmap("<leader>tsc", "<plug>(vimtex-cmd-toggle-star)", "Star (command)")
bufmap("<leader>tse", "<plug>(vimtex-env-toggle-star)", "Star (environment)")
bufmap("<leader>te", "<plug>(vimtex-env-toggle)", "Environment")
bufmap("<leader>t$", "<plug>(vimtex-env-toggle-math)", "Math environment")
bufmap("<leader>tb", "<plug>(vimtex-env-toggle-break)", "Line break")
bufmap("<leader>td", "<plug>(vimtex-delim-toggle-modifier)", "Modifier")
bufmap("<leader>tD", "<plug>(vimtex-delim-toggle-modifier-reverse)", "Reverse modifier")

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    os.execute("pkill zathura")
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd([[write! ]])
  end,
  buffer = vim.api.nvim_get_current_buf(),
  desc = "Autosave on leaving insert mode",
})
