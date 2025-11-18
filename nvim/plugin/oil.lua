local oil = require("oil")
local fzf_lua = require("fzf-lua")
local ns = vim.api.nvim_create_namespace("OilHighlights")

vim.b.search_char = nil
local search_first_char = function(reuse_prompt)
  local buf = 0

  local prompt
  if reuse_prompt then
    prompt = vim.b.search_char
    if prompt == nil then
      vim.print("Can't repeat search without searching!")
      return
    end
  else
    prompt = vim.fn.getcharstr()
  end

  -- Search for the prompt character, limiting the search range to the first
  -- column of every line. Oil has an option called `constrain_cursor`, which
  -- makes it so we can only edit the filename, and not other columns. Jumping
  -- to the start of the line is a surefire way to get the right column for
  -- searching
  vim.api.nvim_feedkeys("^", "n", false)
  local search_col = vim.fn.col(".")
  local regex = "\\%" .. search_col .. "c" .. prompt
  vim.fn.search(regex, "")

  if reuse_prompt then
    return
  end
  vim.b.search_char = prompt

  local num_lines = vim.api.nvim_buf_line_count(buf)
  local lines = vim.api.nvim_buf_get_lines(0, 0, num_lines, false)
  vim.api.nvim_buf_clear_namespace(0, ns, 0, num_lines)

  -- Highlight each line matching the prompted character
  for lnum, line in ipairs(lines) do
    local col = line:sub(search_col, search_col)
    if col == prompt then
      vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, search_col - 1, {
        hl_group = { "DiagnosticWarn" },
        end_col = line:len(),
        id = lnum,
      })
    end
  end
end

oil.setup({
  -- I have the ftplugin ignore the prompt, so we want to make sure nothing
  -- actually gets deleted by accident. In the future I'd like to try out using
  -- the git status of a file, and only prompt if you're deleting a file with
  -- uncommitted changes.
  delete_to_trash = true,

  keymaps = {
    H = "actions.parent",
    L = "actions.select",
    J = false,
    K = false,
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,

    ["<C-f>"] = {
      function()
        search_first_char(false)
      end,
      mode = "n",
    },
    ["<C-;>"] = {
      function()
        search_first_char(true)
      end,
      mode = "n",
    },

    ["<CR>"] = false,
    ["<Esc>"] = {
      ":bd<CR>",
      silent = true,
    },
    ["<Tab>"] = "actions.preview",
    ["gs"] = {
      callback = function()
        sort_by_recent = not sort_by_recent
        if sort_by_recent then
          oil.set_sort({ { "mtime", "desc" } })
          oil.set_columns({
            { "mtime", highlight = "NonText", format = "%b %d" },
            { "icon" },
          })
        else
          oil.set_sort({
            { "type", "asc" },
            { "name", "asc" },
          })
          oil.set_columns({ "icon" })
        end
      end,
      nowait = true, -- Override the existing `gs` bind
    },

    -- Heavily referenced from
    -- https://github.com/samiulsami/nvim/blob/7a72a0c7328ba4dc58bfe4e0d32750a5323f6267/lua/plugins/oil.lua#L94
    ["<leader>s"] = {
      function()
        fzf_lua.live_grep({
          cwd = oil.get_current_dir(),
          actions = {
            ["default"] = function(selected, opts)
              local win = vim.api.nvim_get_current_win()
              vim.api.nvim_win_close(win, false)
              fzf_lua.actions.file_edit(selected, opts)
            end,
          },
        })
      end,
    },
  },
  win_options = {
    signcolumn = "yes",
  },
  float = {
    padding = 10,
  },
})

nnoremap("<leader>e", oil.open_float)
nnoremap("<leader>E", ":Oil --float .<CR>")
