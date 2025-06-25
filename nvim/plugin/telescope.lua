local actions = require("telescope.actions")

local function open_file(j)
  -- Used to be j.path, which is why this wasn't working for me
  local file = j.filename

  if file == nil then
    return
  end

  local line = j.lnum or 1
  local col = j.col or 1

  vim.cmd(string.format("%s %s", "tabedit", file))

  -- Moves the cursor to the proper line and column
  vim.cmd(string.format("normal! %dG%d|", line, col))
end

-- Cobbled together from github.com/nvim-telescope/telescope.nvim/issues/1048.
-- If you select multiple items, each will be opened in their own tab.
local select_one_or_multi = function(prompt_bufnr)
  local state = require("telescope.actions.state")

  local picker = state.get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()

  -- If we only selected one file
  if vim.tbl_isempty(multi) then
    actions.select_tab(prompt_bufnr)

    -- For some reason, my cursor keeps ending up one character to the right of
    -- where it should be
    vim.cmd("normal! h")

    -- Return early. If we keep going, the table wasn't empty
    return
  end

  actions.close(prompt_bufnr)

  for _, j in pairs(multi) do
    open_file(j)
  end
end

require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
  defaults = {
    initial_mode = "normal",

    mappings = {
      n = {
        ["<CR>"] = select_one_or_multi,

        -- By default, tab goes back, and shift-tab goes forward. Gross!
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
      },

      i = {
        ["<CR>"] = select_one_or_multi,
      },
    },
  },
})

require("telescope").load_extension("ui-select")
