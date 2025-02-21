require("bufferline").setup({
  options =
  {
    mode = "tabs"
  },
})

-- Tab management
nnoremap("th", ":tabprev<CR>")
nnoremap("tl", ":tabnext<CR>")

nnoremap("tf", ":tabnew<CR>") -- Create fresh tab
nnoremap("td", ":tabclose<CR>")
