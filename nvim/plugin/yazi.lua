local Yazi = require("yazi")

Yazi.setup({
  open_for_directories = true,
})

-- Open new file from current dir
nnoremap("<leader>y", Yazi.yazi)

-- Open new file from project cwd
nnoremap("<leader>z", function()
  local cwd = vim.fn.getcwd()
  Yazi.yazi({}, cwd)
end)
