require("bufferline").setup({
  options =
  {
    mode = "tabs"
  },
})

-- Tab management
nnoremap("th", ":tabprev<CR>")
nnoremap("tl", ":tabnext<CR>")

nnoremap("tf", ":tabnew New Tab<CR>") -- Create fresh tab
nnoremap("td", ":tabclose<CR>")
