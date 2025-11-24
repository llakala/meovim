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
  -- column of every line.
  --
  -- Oil has an option called `constrain_cursor`, which makes it so we can only
  -- edit the filename, and not other columns.  This is supposed to make sure we
  -- end up at the start of the line before doing search logic, but it doesn't
  -- seem to work - need to make an issue oil-side asking for this to be
  -- queriable
  vim.api.nvim_feedkeys("^", "n", false)
  local search_col = vim.fn.col(".")
  local pattern = "\\%" .. search_col .. "c" .. prompt
  vim.fn.search(pattern, "")

  -- Exit early in `<C-;> mode`, so we don't regenerate highlights for no reason
  if reuse_prompt then
    return
  end

  vim.b.search_char = prompt
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  -- Iterate through all the matched lines and highlight them
  -- Note that we need to use `bufnr()` - bufnr of 0 doesn't work for matchbufline!
  local matches = vim.fn.matchbufline(vim.fn.bufnr(), pattern, 1, "$")
  for _, match in ipairs(matches) do
    local line = unpack(vim.api.nvim_buf_get_lines(buf, match.lnum - 1, match.lnum, true))
    local col = string.sub(line, search_col, search_col)

    if col == prompt then
      vim.api.nvim_buf_set_extmark(buf, ns, match.lnum - 1, search_col - 1, {
        hl_group = { "DiagnosticWarn" },
        end_col = line:len(),
        id = match.lnum,
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
    ["<leader>s"] = function()
      fzf_lua.live_grep({
        cwd = oil.get_current_dir(),
        cwd_prompt = true,
        actions = {
          ["default"] = function(selected, opts)
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win, false)
            fzf_lua.actions.file_edit(selected, opts)
          end,
        },
      })
    end,

    -- Disable for now, so I don't try it and expect it to work
    ["<leader>f"] = function() end,
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
