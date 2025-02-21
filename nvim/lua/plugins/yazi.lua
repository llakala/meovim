require("yazi").setup()

-- Function from yazi.nvim source that opens files in new tab
local openNewTab = function(chosen_file, config, state)
  local is_directory = vim.fn.isdirectory(chosen_file) == 1
  if not is_directory then
    vim.cmd(string.format("tabedit %s", vim.fn.fnameescape(chosen_file)))
  end
end


-- Open Yazi, but with open_file_function overriden to open all files in new tabs
-- We do this rather than specifying a keybind for this
-- This is because if we set open_file_in_tab to something like `o`,
-- it would mess up typing `o` in zoxide.
nnoremap("tt", function()
  require("yazi").yazi({
    open_file_function = openNewTab
  })
end)

-- Open in current tab
nnoremap("to", ":Yazi<CR>")
