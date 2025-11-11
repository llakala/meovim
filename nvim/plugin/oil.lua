vim.b.prev_qf_size = #vim.fn.getqflist()

local oil = require("oil")
oil.setup({
  keymaps = {
    H = "actions.parent",
    L = "actions.select",
    J = "j",
    K = "k",
    ["<C-h>"] = "actions.parent",
    ["<C-l>"] = "actions.select",
    ["<C-j>"] = "j",
    ["<C-k>"] = "k",
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
