local oil = require("oil")
vim.api.nvim_buf_create_user_command(0, "WriteOil", function()
  oil.save({ confirm = false })
end, {})

vim.cmd([[
  :cabbrev <buffer> <silent> w WriteOil
  :cabbrev <buffer> <silent> wq execute 'WriteOil' <bar> qa
  :cabbrev <buffer> <silent> wd execute 'WriteOil' <bar> q
]])

-- From https://github.com/stevearc/oil.nvim/issues/310#issuecomment-2019214285
-- Deletes a buffer when the file is deleted on the Oil side! Happy and
-- surprised to see someone already wrote this
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(args)
    local parse_url = function(url)
      return url:match("^.*://(.*)$")
    end

    if args.data.err then
      return
    end

    for _, action in ipairs(args.data.actions) do
      if action.type == "delete" and action.entry_type == "file" then
        local path = parse_url(action.url)
        local bufnr = vim.fn.bufnr(path)
        if bufnr == -1 then
          return
        end

        local winnr = vim.fn.win_findbuf(bufnr)[1]
        if not winnr then
          return
        end

        vim.fn.win_execute(winnr, "bfirst | bd" .. bufnr)
      end
    end
  end,
})
