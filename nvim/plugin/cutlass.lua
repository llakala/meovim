require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  cut_key = nil,
})

-- Doing this myself, since I trust myself to set it up correctly
nnoremap("q", "d", "Delete and yank")
onoremap("q", "d", "Delete and yank")
