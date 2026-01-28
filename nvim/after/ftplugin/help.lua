-- Follow and return from tag link
nnoremap("<CR>", "<C-]>", { buffer = true })
nnoremap("<BS>", "<C-T>", { buffer = true })

-- Color tag links blue to be more visually distinct from mini.cursorword
vim.api.nvim_set_hl(0, "@markup.link.vimdoc", { fg = colors.blue })

vim.opt_local.wrap = false
vim.b.miniindentscope_disable = true
