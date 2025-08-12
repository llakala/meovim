vim.cmd([[
  " Put buffer by itself, rather than using a split
  only

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
