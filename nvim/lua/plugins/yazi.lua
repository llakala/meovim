require("yazi").setup({
  open_for_directories = true, -- Use yazi instead of netrw

  keymaps = {
    open_file_in_tab = "t", -- Open in neovim tab, not Yazi tab.
  },
})

nnoremap("to", ":Yazi toggle<CR>")
