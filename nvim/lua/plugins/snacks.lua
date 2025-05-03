Snacks = require("snacks")

-- Global for making a picker open selected files in a new tab. We set it in both
-- `list` and `inputs`, so whether you type for a file or scroll to it, it'll behave
-- the same. Uses my custom action, documented below this
---@class snacks.picker.win.Config
snacks_new_tab = {
  list = {
    keys = {
      ["<CR>"] = { "open_or_create", mode = { "n", "i" } },
    },
  },
  input = {
    keys = {
      ["<CR>"] = { "open_or_create", mode = { "n", "i" } },
    },
  },
}

-- Jump function taken from the snacks source, but modified slightly to work better
-- with multiple tabs. Now, if the current tab list contains the buffer we want,
-- it'll be swapped to. If not, it'll be opened in a new tab. The original source
-- hardcodes the tab swap functionality and the new tab functionality to not work
-- together... we just change the condition to not be so mean. If you want to see
-- the parts of the code that I changed, search for `CHANGED:`
local function open_or_create(picker, _, action)
  ---@cast action snacks.picker.jump.Action
  -- if we're still in insert mode, stop it and schedule
  -- it to prevent issues with cursor position
  if vim.fn.mode():sub(1, 1) == "i" then
    vim.cmd.stopinsert()
    vim.schedule(function()
      open_or_create(picker, _, action)
    end)
    return
  end

  local items = picker:selected({ fallback = true })

  if picker.opts.jump.close then
    picker:close()
  else
    vim.api.nvim_set_current_win(picker.main)
  end

  if #items == 0 then
    return
  end

  local win = vim.api.nvim_get_current_win()

  local current_buf = vim.api.nvim_get_current_buf()
  local current_empty = vim.bo[current_buf].buftype == ""
    and vim.bo[current_buf].filetype == ""
    and vim.api.nvim_buf_line_count(current_buf) == 1
    and vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)[1] == ""
    and vim.api.nvim_buf_get_name(current_buf) == ""

  if not current_empty then
    -- save position in jump list
    if picker.opts.jump.jumplist then
      vim.api.nvim_win_call(win, function()
        vim.cmd("normal! m'")
      end)
    end

    -- save position in tag stack
    if picker.opts.jump.tagstack then
      local from = vim.fn.getpos(".")
      from[1] = current_buf
      local tagstack = { { tagname = vim.fn.expand("<cword>"), from = from } }
      vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")
    end
  end

  -- CHANGED: Hardcoded to always open in a new tab (if the buffer isn't already
  -- open)
  local cmd = "tab sbuffer"

  if cmd:find("drop") then
    local drop = {} ---@type string[]
    for _, item in ipairs(items) do
      local path = item.buf and vim.api.nvim_buf_get_name(item.buf) or Snacks.picker.util.path(item)
      if not path then
        Snacks.notify.error("Either item.buf or item.file is required", { title = "Snacks Picker" })
        return
      end
      drop[#drop + 1] = vim.fn.fnameescape(path)
    end
    vim.cmd(cmd .. " " .. table.concat(drop, " "))
  else
    for i, item in ipairs(items) do
      -- load the buffer
      local buf = item.buf ---@type number
      if not buf then
        local path = assert(Snacks.picker.util.path(item), "Either item.buf or item.file is required")
        buf = vim.fn.bufadd(path)
      end
      vim.bo[buf].buflisted = true

      -- CHANGED: I want this to always trigger, so I remove the conditions that
      -- originally checked if the option was set and if the cmd was set to `buffer`
      if #items == 1 and buf ~= current_buf then
        for _, w in ipairs(vim.fn.win_findbuf(buf)) do
          if vim.api.nvim_win_get_config(w).relative == "" then
            win = w
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end

      -- open the first buffer
      if i == 1 then
        vim.cmd(("%s %d"):format(cmd, buf))
        win = vim.api.nvim_get_current_win()
      end
    end
  end

  -- set the cursor
  local item = items[1]
  local pos = item.pos
  if picker.opts.jump.match then
    pos = picker.matcher:bufpos(vim.api.nvim_get_current_buf(), item) or pos
  end
  if pos and pos[1] > 0 then
    vim.api.nvim_win_set_cursor(win, { pos[1], pos[2] })
    vim.cmd("norm! zzzv")
  elseif item.search then
    vim.cmd(item.search)
    vim.cmd("noh")
  end

  -- HACK: this should fix folds
  if vim.wo.foldmethod == "expr" then
    vim.schedule(function()
      vim.o.foldmethod = "expr"
    end)
  end

  if current_empty and vim.api.nvim_buf_is_valid(current_buf) then
    local w = vim.fn.win_findbuf(current_buf)
    if #w == 0 then
      vim.api.nvim_buf_delete(current_buf, { force = true })
    end
  end
end

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
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none" },
    },
  },
}

require("snacks").setup({
  quickfile = { enabled = true },
  input = { enabled = true }, -- Doesn't replace all input, but will work for stuff like lsp renames
  picker = {
    enabled = true,
    focus = "list", -- Start in normal mode
    ui_select = true,

    actions = {
      open_or_create = open_or_create,
    },

    layouts = {
      custom = custom_layout,
    },
  },
})

vim.ui.input = "Snacks.input"
vim.ui.select = "Snacks.picker.select"
