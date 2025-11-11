local oil = require("oil")
vim.api.nvim_buf_create_user_command(0, "WriteOil", function()
  oil.save({ confirm = false })
end, {})

vim.cmd([[
  :cabbrev <buffer> <silent> w WriteOil
  :cabbrev <buffer> <silent> wq execute 'WriteOil' <bar> q
]])
