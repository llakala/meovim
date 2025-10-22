o.wrap = true
o.textwidth = 120
vim.opt_local.formatoptions:append({ t = true }) -- Wrap all text, not just comments

vim.keymap.set("n", "<leader>p", vim.cmd.MarkdownPreview, { buffer = true })
