-- See the comment in ./help.lua - opens all git stuff in new tabs
vim.cmd([[
  autocmd BufEnter <buffer> silent wincmd T
]])
