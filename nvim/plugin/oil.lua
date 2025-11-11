vim.b.prev_qf_size = #vim.fn.getqflist()

local oil = require("oil")
oil.setup({
  keymaps = {
    H = "actions.parent",
    L = "actions.select",
    ["<C-h>"] = "actions.parent",
    ["<C-l>"] = "actions.select",
    ["<CR>"] = false,
    ["<Esc>"] = ":bd<CR>",
  },
  win_options = {
    signcolumn = "yes",
  },
  float = {
    padding = 10,
  },
})

nnoremap("<leader>e", oil.open_float)
nnoremap("<leader>E", ":Oil --float .<CR>")
