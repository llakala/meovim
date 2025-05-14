require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  cut_key = nil,
})

-- Do this ourselvews, using noremap instead of nnoremap
-- Means that it works in the operator pending mode, and we can have numbers as
-- motions
noremap("q", "d")
