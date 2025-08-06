local actions = require("telescope.actions")
local builtins = require("telescope.builtin")

-- Cobbled together from github.com/nvim-telescope/telescope.nvim/issues/1048.
-- If you select multiple items, each will be opened in their own tab.
local use_tab_func = function(prompt_bufnr)
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
end

local open_files_in_tabs = {
  initial_mode = "normal",
  mappings = {
    n = {
      ["<CR>"] = use_tab_func,

      -- By default, tab goes back, and shift-tab goes forward. Gross!
      ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
      ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
    },

    i = {
      ["<CR>"] = use_tab_func,
    },
  },
}

require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
  pickers = {
    buffers = open_files_in_tabs,
    lsp_definitions = open_files_in_tabs,
    lsp_references = open_files_in_tabs,
    diagnostics = open_files_in_tabs,
  },
})

require("telescope").load_extension("ui-select")

-- i for implementation
nnoremap("<leader>i", function()
  builtins.lsp_definitions()
end, { desc = "View implementation" })

-- u for usage
nnoremap("<leader>u", function()
  builtins.lsp_references()
end, { desc = "View usage(s)" })

-- w for workspace. Shows workspace diagnostics, so you can see errors in other
-- files. Great for Gleam dev, since the Gleam LSP gets stuck if one file has errors.
-- Note that this doesn't work for all LSPs!
nnoremap("<leader>w", function()
  builtins.diagnostics()
end, { desc = "Workspace diagnostics" })
