vim.cmd([[
  " See the comment in ./help.lua - opens all fugitive stuff in new tabs
  autocmd BufEnter <buffer> silent wincmd T

  " Remove the default d binds, so we can map `d` to inline diff
  nunmap <buffer> dp
  nunmap <buffer> dd
  nunmap <buffer> dv
  nunmap <buffer> ds
  nunmap <buffer> dh
  nunmap <buffer> dq
  nunmap <buffer> d?
]])

-- d for diff
bufmap("d", "<plug>fugitive:=")

-- Always open in new tab
bufmap("o", "<plug>fugitive:O")
