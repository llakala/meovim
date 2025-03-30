Snacks = require("snacks")

-- Global for making a picker open selected files in a new tab. We set it in both
-- `list` and `inputs`, so whether you type for a file or scroll to it, it'll behave
-- the same. Snacks is smart and doesn't use the new tab if the instance we selected
-- was in the file we're currently in.
snacks_new_tab = {
  list = {
    keys = {
      ["<CR>"] = { "tab", mode = { "n", "i" } },
    },
  },
  input = {
    keys = {
      ["<CR>"] = { "tab", mode = { "n", "i" } },
    },
  },
}

-- Layout based off the dropdown layout, but with 100% width
local custom_layout = {
  layout = {
    backdrop = false,
    row = 1,
    width = 0.4,
    min_width = 100,
    height = 0.8,
    border = "none",
    box = "vertical",
    { win = "preview", title = "{preview}", height = 0.4, border = "rounded" },
    {
      box = "vertical",
      border = "rounded",
      title = "{title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1,     border = "bottom" },
      { win = "list",  border = "none" },
    },
  },
}

Snacks.setup({
  quickfile = { enabled = true },
  input = { enabled = true }, -- Doesn't replace all input, but will work for stuff like lsp renames
  picker = {
    enabled = true,
    focus = "list", -- Start in normal mode
    ui_select = true,

    layouts = {
      custom = custom_layout
    }
  },
})

vim.ui.input = "Snacks.input"
vim.ui.select = "Snacks.picker.select"
