require("cutlass").setup({
  -- The default behavior doesn't handle something like `q2q`
  -- I set up the key myself
  cut_key = nil,
})

-- anoremap maps for normal, visual, and operator mode
anoremap("<A-d>", "d", { desc = "Delete and yank" })
anoremap("<A-S-d>", "D", { desc = "Delete until end of line" })
