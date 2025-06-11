-- Follow and return from tag link
nnoremap("<CR>", "<C-]>", { buffer = true })
nnoremap("<BS>", "<C-T>", { buffer = true })

-- Color tag links blue to be more visually distinct from mini.cursorword
vim.api.nvim_set_hl(0, "@markup.link.vimdoc", { fg = colors.blue })

local o = vim.opt_local
o.wrap = false
vim.b.miniindentscope_disable = true

-- Put help page in new tab when opened. Better than cabbrev, since this
-- always triggers, even when copy/pasting something into cmdline!
vim.cmd("silent wincmd T")
