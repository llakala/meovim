local oil = require("oil")
local utils = require("oil.util")
local fzf_lua = require("fzf-lua")
local ns = vim.api.nvim_create_namespace("OilHighlights")

vim.b.search_char = nil
local search_first_char = function(reuse_prompt, forward)
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

  -- Oil has an option called `constrain_cursor`, which makes it so we can only
  -- edit the filename, and not other columns.  This is supposed to make sure we
  -- end up at the start of the line before doing search logic, but it doesn't
  -- seem to work - need to make an issue oil-side asking for this to be
  -- queriable
  vim.api.nvim_feedkeys("^", "n", false)

  -- Search for the prompt character, limiting the search range to the first
  -- column of every line.
  local search_col = vim.fn.col(".")
  local pattern = "\\%" .. search_col .. "c" .. prompt
  local flags = forward and "" or "b"
  vim.fn.search(pattern, flags)

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

-- The oil logic for qflist stuff only allows you to add a range or a search
-- pattern. I want to add the current entry most often, so this adds support for
-- that.
local function add_to_qflist()
  local message = {}
  local dir = oil.get_current_dir()
  local current_qflist = vim.fn.getqflist()
  local qf_entries = {}

  local qf_action = nil
  if vim.g.just_entered_oil and #current_qflist > 0 then
    qf_action = "r"
    table.insert(message, "Deleting current entries, adding '")
  else
    qf_action = "a"
    table.insert(message, "Adding '")
  end

  local function add_file(entry, index)
    if entry and entry.type == "file" then
      if index == 1 then
        table.insert(message, entry.name)
      else
        table.insert(message, ", " .. entry.name)
      end
      local qf_entry = {
        filename = dir .. entry.name,
        lnum = 1,
        col = 1,
        text = entry.name,
      }
      table.insert(qf_entries, qf_entry)
    end
  end

  if not utils.is_visual_mode() then
    local entry = oil.get_cursor_entry()
    add_file(entry, 1)
  else
    local range = utils.get_visual_range()
    if range == nil then
      return
    end
    for i = range.start_lnum, range.end_lnum do
      local entry = oil.get_entry_on_line(0, i)
      add_file(entry, i - range.start_lnum + 1)
    end
  end

  table.insert(message, "' to qflist")
  vim.print(table.concat(message))

  if #qf_entries == 0 then
    vim.notify("[oil] No entries found to send to quickfix", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_exec_autocmds("QuickFixCmdPre", {})
  local qf_title = "oil files"
  vim.fn.setqflist({}, qf_action, { title = qf_title, items = qf_entries })

  vim.g.open_qf_on_quit = true -- I have this handled in the oil ftplugin
  vim.g.just_entered_oil = false
end

oil.setup({
  -- I have the ftplugin ignore the prompt, so we want to make sure nothing
  -- actually gets deleted by accident. In the future I'd like to try out using
  -- the git status of a file, and only prompt if you're deleting a file with
  -- uncommitted changes.
  delete_to_trash = true,

  keymaps = {
    ["<C-h>"] = "actions.parent",
    -- actions.select but without the list of changes to be performed, since I
    -- live my life on the edge
    ["<C-l>"] = {
      "actions.select",
      opts = {
        -- Added in my personal fork (will upstream at some point)
        confirm = false,
      },
    },

    -- TODO: enable again when my intuition is fixed
    H = false,
    J = false,
    K = false,
    L = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,

    -- Print path to current entry
    ["g~"] = function()
      local dir = oil.get_current_dir()
      local entry = oil.get_cursor_entry()
      if entry == nil then
        return
      end
      vim.print(dir .. entry.name)
    end,

    ["<C-f>"] = {
      function()
        search_first_char(false, true)
      end,
      mode = "n",
    },
    ["<C-;>"] = {
      function()
        search_first_char(true, true)
      end,
      mode = "n",
    },
    ["<C-,>"] = {
      function()
        search_first_char(true, false)
      end,
      mode = "n",
    },

    ["<CR>"] = false,
    ["<Esc>"] = {
      ":bd<CR>",
      mode = "n",
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

    ["<C-a>"] = add_to_qflist,

    -- Heavily referenced from
    -- https://github.com/samiulsami/nvim/blob/7a72a0c7328ba4dc58bfe4e0d32750a5323f6267/lua/plugins/oil.lua#L94
    ["<leader>s"] = function()
      fzf_lua.live_grep({
        cwd = oil.get_current_dir(),
        cwd_prompt = true,
        actions = {
          ["default"] = function(selected, opts)
            oil.close()
            fzf_lua.actions.file_edit(selected, opts)
          end,
        },
      })
    end,

    ["<leader>f"] = function()
      fzf_lua.files({
        cwd = oil.get_current_dir(),
        actions = {
          ["default"] = function(selected, opts)
            oil.close()
            fzf_lua.actions.file_edit(selected, opts)
          end,
        },
      })
    end,
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
