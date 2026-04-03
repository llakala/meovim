local group = vim.api.nvim_create_augroup("OpenQuickfixIfChanged", {})

-- vim.g.qflist_size = #vim.fn.getqflist()
-- vim.api.nvim_create_autocmd("WinLeave", {
--   group = group,
--   callback = function()
--     local size = #vim.fn.getqflist()
--     if vim.g.qflist_size == size then
--       return
--     end
--     vim.g.qflist_size = size
--
--     vim.cmd.copen()
--     local buffers = vim.fn.getbufinfo()
--     local qf_id = nil
--     for _, buf in pairs(buffers) do
--       if vim.fn.getbufvar(buf.bufnr, "&buftype") == "quickfix" then
--         qf_id = buf.bufnr
--       end
--     end
--     if qf_id == nil then
--       vim.print("Was nil!")
--     else
--       vim.print(qf_id)
--       vim.w[0].canola_original_buffer = qf_id
--     end
--   end,
-- })

vim.keymap.set("n", "<leader>f", "<Nop>", { buffer = true })

vim.api.nvim_create_autocmd("QuickFixCmdPre", {
  group = group,
  buffer = 0,
  callback = function()
    vim.api.nvim_create_autocmd("WinClosed", {
      once = true,
      group = group,
      buffer = 0,
      callback = function()
        vim.cmd.copen()
      end,
    })
  end,
})
