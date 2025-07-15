vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
})

-- When unsuspending, check if the file has been modified outside of nvim. If
-- so, give us a notification to choose what to do. Not a very pretty
-- notification - I really need a plugin for this. But better than nothing!
vim.api.nvim_create_autocmd("VimResume", {
  pattern = "*",
  command = "checktime",
})
-- If this is on, it'll auto-reload the file if we didn't change it. We don't
-- want that - we can do it ourselves. We just want to know.
vim.o.autoread = false
