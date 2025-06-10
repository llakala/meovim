require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  cut_key = nil,
})

-- Doing this myself, since I trust myself to set it up correctly
nnoremap("q", "d", { desc = "Delete and yank" })
onoremap("q", "d", { desc = "Delete and yank" })
vnoremap("q", "d", { desc = "Delete and yank" })
