-- Follow and return from tag link
nnoremap("<CR>", "<C-]>", { buffer = true })
nnoremap("<BS>", "<C-T>", { buffer = true })

-- Color tag links blue to be more visually distinct from mini.cursorword
vim.api.nvim_set_hl(0, "@markup.link.vimdoc", { fg = colors.blue })

local o = vim.opt_local
o.wrap = false
vim.b.miniindentscope_disable = true

-- From https://stackoverflow.com/a/69190346 (I replied with my solution)
-- Puts help page in new tab when opened. Better than cabbrev, since this
-- always triggers, even when copy/pasting something into cmdline!
--
-- Simply doing `wincmd T` doesn't work when the file already exists in another
-- tab. I tried to use BufRead instead of BufEnter, but it didn't seem to work -
-- so we're stuck with `silent` to not constantly trigger messages upon
-- switching. A nice improvement would be a good if statement, so it only runs
-- `wincmd T` if it's not already the only buffer on the page.
vim.cmd([[
  autocmd BufEnter <buffer> silent wincmd T
]])
