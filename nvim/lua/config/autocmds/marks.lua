-- Core code logic from https://github.com/nathanmsmith/.config/blob/f8abcc3a0a4e81424cd27bdab5d947c0edfa9d1b/nvim/lua/marks.lua#L1
-- Modified to fit my purposes, match my code aesthetics, and remove features I
-- didn't use.
--
-- Renders marks when loading a buffer, and adds mark deletion keybinds (dma to
-- delete mark a, dM to delete all marks). Uses the nightly 0.12 MarkSet autocmd
-- (which was added by nathanmsmith, ty!)
local M = {}

M.config = {
  priority = 100,
  group = "MarkGutter",
  name_prefix = "MarkGutter_",
}

-- Give all marks (global and local) for a current buffer.
---@param bufnr number Buffer number to get marks for
---@return vim.fn.getmarklist.ret.item[] List of marks where keys are mark names (a-z for local, A-Z for global) and values contain line/column positions
function M.list_all_marks_for_buffer(bufnr)
  local local_marks = vim.fn.getmarklist(bufnr)
  local global_marks = vim.tbl_filter(function(mark)
    -- pos is a 4-tuple with the bufnr, lnum, col, offset. See `:h getmarklist()`.
    local global_mark_bufnr = mark.pos[1]
    return global_mark_bufnr == bufnr
  end, vim.fn.getmarklist())

  return vim.list_extend(local_marks, global_marks)
end

function M.render_mark(bufnr, mark, lnum)
  vim.fn.sign_place(mark:byte(), M.config.group, M.config.name_prefix .. mark, bufnr, {
    lnum = lnum,
    priority = M.config.priority,
  })
end

-- Rerender all marks in the sign column
function M.render_all_marks(bufnr)
  -- Clear all existing marks
  vim.fn.sign_unplace(M.config.group, { buffer = bufnr })

  -- Get all marks
  local all_marks = M.list_all_marks_for_buffer(bufnr)

  -- Place signs for each mark
  for _, mark in ipairs(all_marks) do
    -- Extract the character from 'x
    local mark_char = mark.mark:sub(2, 2)

    if mark_char:match("[a-zA-Z]") then
      vim.fn.sign_place(mark_char:byte(), M.config.group, M.config.name_prefix .. mark_char, bufnr, {
        lnum = mark.pos[2],
        priority = M.config.priority,
      })
    end
  end
end

function M.delete_mark(mark)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace(M.config.group, { buffer = bufnr, id = mark:byte() })
  vim.cmd("delmarks " .. mark)
end

function M.delete_all_marks()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace(M.config.group, { buffer = bufnr })
  vim.cmd("delmarks A-Za-z")
end

function M.setup(user_config)
  -- Merge user config with defaults
  if user_config then
    M.config = vim.tbl_deep_extend("force", M.config, user_config)
  end

  -- Define highlight groups
  vim.api.nvim_set_hl(0, "MarkGutterLower", { link = "DiagnosticSignOk", default = true })
  vim.api.nvim_set_hl(0, "MarkGutterUpper", { link = "DiagnosticSignOk", default = true })

  -- Lowercase marks (a-z)
  for i = 97, 122 do
    local char = string.char(i)
    vim.fn.sign_define(M.config.name_prefix .. char, {
      text = char,
      texthl = "MarkGutterLower",
      linehl = "",
      numhl = "",
    })
  end

  -- Uppercase marks (A-Z)
  for i = 65, 90 do
    local char = string.char(i)
    vim.fn.sign_define(M.config.name_prefix .. char, {
      text = char,
      texthl = "MarkGutterUpper",
      linehl = "",
      numhl = "",
    })
  end

  local augroup = vim.api.nvim_create_augroup(M.config.group, { clear = true })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup,
    callback = function(event)
      M.render_all_marks(event.buf)
    end,
  })

  vim.api.nvim_create_autocmd("MarkSet", {
    group = augroup,
    callback = function(event)
      M.render_mark(event.buf, event.data.name, event.data.line)
    end,
  })

  vim.keymap.set("n", "dm", function()
    local mark = vim.fn.getcharstr()
    M.delete_mark(mark)
  end, { desc = "Delete mark" })

  vim.keymap.set("n", "dM", function()
    M.delete_all_marks()
  end, { desc = "Delete all marks" })
end

if vim.fn.has("nvim-0.12") == 1 then
  M.setup()
else
  vim.print("Nightly neovim required!")
end
