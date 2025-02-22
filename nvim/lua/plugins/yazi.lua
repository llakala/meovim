require("yazi").setup()

-- Function from yazi.nvim source that opens files in new tab
local openNewTab = function(chosen_file, cfg, state)
  local is_directory = vim.fn.isdirectory(chosen_file) == 1
  if not is_directory then
    vim.cmd(string.format("tabedit %s", vim.fn.fnameescape(chosen_file)))
  end
end

-- When selecting multiple files in Yazi, open them all in new tabs
local openMultipleNewTab = function(chosen_files, cfg, state)
  for _, chosen_file in ipairs(chosen_files) do
    openNewTab(chosen_file, cfg, state)
  end
end

-- Open in current tab
-- I'd like to have opened_multiple_files open the first file in the current editor,
-- then open the rest in new tabs, but I couldn't get that working
nnoremap("to", function()
  require("yazi").yazi({
    hooks = {
      yazi_opened_multiple_files = openMultipleNewTab
    }
  })
end)

-- Open Yazi, but with open_file_function overriden to open all files in new tabs
-- We do this rather than specifying a keybind for this
-- This is because if we set open_file_in_tab to something like `o`,
-- it would mess up typing `o` in zoxide.
nnoremap("tt", function()
  require("yazi").yazi({
    open_file_function = openNewTab,
    hooks = {
      yazi_opened_multiple_files = openMultipleNewTab
    }
  })
end)
