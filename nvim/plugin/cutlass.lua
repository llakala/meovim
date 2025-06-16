require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  cut_key = nil,
})

-- Doing this myself, since I trust myself to set it up correctly
nnoremap("D", "d", { desc = "Delete and yank" })
onoremap("D", "d", { desc = "Delete and yank" })
vnoremap("D", "d", { desc = "Delete and yank" })
