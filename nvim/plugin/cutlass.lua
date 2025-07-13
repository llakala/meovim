require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  -- I set up the key myself
  cut_key = nil,
})

nnoremap("<A-d>", "d", { desc = "Delete and yank" })
onoremap("<A-d>", "d", { desc = "Delete and yank" })
vnoremap("<A-d>", "d", { desc = "Delete and yank" })

nnoremap("<A-S-d>", "D", { desc = "Delete until end of line" })
onoremap("<A-S-d>", "D", { desc = "Delete until end of line" })
vnoremap("<A-S-d>", "D", { desc = "Delete until end of line" })
