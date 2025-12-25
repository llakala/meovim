require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  -- I set up the key myself
  cut_key = nil,
})

-- Since timeout is disabled, this makes `dyip` delete the current word and yank
-- it
nnoremap("dy", "d", { desc = "Delete and yank" })
nnoremap("cy", "c", { desc = "Change and yank" })

vnoremap("D", "d", { desc = "Delete and yank" })
vnoremap("C", "c", { desc = "Change and yank" })
