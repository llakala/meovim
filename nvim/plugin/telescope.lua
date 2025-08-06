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
    },

    i = {
      ["<CR>"] = use_tab_func,
    },
  },
}

local jump_to_tab = {
  jump_type = "tab",
}

require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
  pickers = {
    diagnostics = open_files_in_tabs,
    lsp_references = open_files_in_tabs,

    lsp_definitions = jump_to_tab,
    lsp_type_definitions = jump_to_tab,
  },
})

require("telescope").load_extension("ui-select")

-- Replace default LSP bindings with telescope equivalents
-- We don't mess with rename and code actions, bc telescope has no equivalent
-- for them
nnoremap("grr", builtins.lsp_references, { desc = "View usage(s)" })
nnoremap("gri", builtins.lsp_definitions, { desc = "View implementation" })
nnoremap("grt", builtins.lsp_type_definitions, { desc = "View implementation" })
nnoremap("gO", builtins.lsp_document_symbols, { desc = "View implementation" })

-- Shows workspace diagnostics, so you can see errors in other files. Great for
-- Gleam dev, since the Gleam LSP gets stuck if one file has errors. Note that
-- this doesn't work for all LSPs!
nnoremap("grd", builtins.diagnostics, { desc = "Workspace diagnostics" })
