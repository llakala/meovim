-- Follow and return from tag link
noremap("<CR>", "<C-]>")
noremap("<BS>", "<C-T>")

-- Color tag links blue to be more visually distinct from mini.cursorword
vim.api.nvim_set_hl(0, "@markup.link.vimdoc", { fg = colors.blue })

local o = vim.opt_local
o.wrap = false
vim.b.miniindentscope_disable = true
