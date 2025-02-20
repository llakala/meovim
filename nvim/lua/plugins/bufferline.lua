require("bufferline").setup()

-- Tab management
nnoremap("th", ":BufferLineCyclePrev<CR>")
nnoremap("tl", ":BufferLineCycleNext<CR>")

nnoremap("tt", ":ene<CR>")
nnoremap("td", ":bdelete<CR>")
