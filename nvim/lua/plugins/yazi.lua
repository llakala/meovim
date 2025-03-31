-- Function from yazi.nvim source that opens files in new tab
local openNewTab = function(chosen_file, _, _)
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

local yazi = require("yazi")

yazi.setup({
  open_for_directories = true,

  -- Override open_file_function to open all files in new tabs
  -- We do this rather than specifying a keybind for this
  -- This is because if we set open_file_in_tab to something like `o`,
  -- it would mess up typing `o` in zoxide.
  hooks = {
    yazi_opened_multiple_files = openMultipleNewTab,
  },
})

-- Replace current tab, starting Yazi from the location of the current file
-- Note that if opening multiple files, they'll all be in new tabs
nnoremap("to", function()
  yazi.yazi()
end)

-- Create a new tab, starting Yazi from the location of the current file
nnoremap("tt", function()
  yazi.yazi({
    open_file_function = openNewTab,
  })
end)

-- Create a new tab from wherever Yazi was last opened. Same as `Yazi toggle`, but
-- using Lua so I can make things open in new tabs. Sadly doesn't seem to bring back
-- the last filter, which is why I wanted this :(. Made an issue for that
-- functionality here: https://github.com/mikavilpas/yazi.nvim/issues/862
nnoremap("ta", function()
  local path = yazi.previous_state and yazi.previous_state.last_hovered or nil

  if path then
    yazi.yazi({
      open_file_function = openNewTab,
    }, path, { reveal_path = path })
  else
    yazi.yazi({
      open_file_function = openNewTab,
    }, path)
  end
end)

-- Replace current tab with a file from the current directory. Great for if you
-- accidentally opened some other directory and want to go back to normalcy
-- TODO: rewrite in lua so this also opens in a new tab (may be hacky as I'm)
-- not sure if there's a lua equivalent in the public config
nnoremap("tc", ":Yazi cwd<cr>")
