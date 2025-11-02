o.textwidth = 120
vim.opt_local.formatoptions:append({ t = true }) -- Wrap all text, not just comments

-- We don't call `setup` since it does its own binary nonsense - we just need
-- the commands to exist
require("typst-preview.commands").create_commands()
vim.keymap.set("n", "<leader>p", vim.cmd.TypstPreview, { buffer = true })
