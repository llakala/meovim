require("bufferline").setup({
  options =
  {
    mode = "tabs"
  },
})

-- Tab management
nnoremap("th", ":tabprev<CR>")
nnoremap("tl", ":tabnext<CR>")

nnoremap("tt", ":tabnew<CR>")
nnoremap("td", ":tabclose<CR>")
