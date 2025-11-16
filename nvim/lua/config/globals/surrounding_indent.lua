-- Heavily modified version of https://github.com/neovim/neovim/discussions/34221
-- Provides a textobject function to work with surrounding indentation levels!
-- I cleaned up the logic for readability, and fixed a few bugs I found.

---@param from integer
---@param dir -1|1
local ilines = function(from, dir)
  local lnum = from
  local min, max = 1, vim.api.nvim_buf_line_count(0)
  return function()
    if lnum < min or lnum > max then
      return nil
    end
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
    local curr = lnum
    lnum = lnum + dir
    return curr, line
  end
end

---@param line_number integer
local find_scope = function(line_number)
  -- Find indent
  local i, j ---@type integer, integer
  for lnum, line in ilines(line_number, -1) do
    if vim.trim(line) ~= "" then
      i = lnum
      break
    end
  end
  for lnum, line in ilines(line_number, 1) do
    if vim.trim(line) ~= "" then
      j = lnum
      break
    end
  end
  if not i or not j then
    return nil, -1, -1
  end
  local indent = math.min(vim.fn.indent(i), vim.fn.indent(j))
  if indent < 1 then
    return nil, -1, -1
  end

  -- Find edges
  local outer_start, outer_end ---@type integer?, integer?
  for lnum, line in ilines(i, -1) do
    if vim.trim(line) ~= "" and vim.fn.indent(lnum) < indent then
      outer_start = lnum
      break
    end
  end
  for lnum, line in ilines(j, 1) do
    if vim.trim(line) ~= "" and vim.fn.indent(lnum) < indent then
      outer_end = lnum
      break
    end
  end
  if not outer_start or not outer_end then
    return nil, -1, -1
  end

  return outer_start, outer_end, indent
end

---@param line_number integer
---@param count integer
local get_scope = function(line_number, count)
  local outer_start, outer_end, indent

  while count >= 1 do
    outer_start, outer_end, indent = find_scope(line_number)
    if not outer_start then
      return nil
    end
    count = count - 1
    line_number = outer_start
  end

  if not outer_start then
    return nil
  end

  local inner_start, inner_end = outer_start + 1, outer_end - 1

  local scope = {
    outer_start = outer_start - 1,
    outer_end = outer_end - 1,
    inner_start = inner_start - 1,
    inner_end = inner_end - 1,
    indent = indent,
    indent_width = indent - vim.fn.indent(outer_start),
  }

  return scope
end

Custom.delete_surrounding_indent = function()
  local win = vim.api.nvim_get_current_win()
  local buf = 0

  local row, col = unpack(vim.api.nvim_win_get_cursor(win))

  -- This function gets called normally through `vim.keymap.set` for something
  -- like `ysi` - but `dsi` and `csi` are overriden by nvim-surround, which
  -- doesn't pass us the normal `vim.v` operators. We add special "v:operator-at-home"
  -- logic to get around this
  local mode = vim.api.nvim_get_mode()
  local operator, count1
  if mode.mode:find("o") then
    operator, count1 = vim.v.operator, vim.v.count1
  else
    count1 = 1 -- Couldn't find a way to query this from nvim-surround
    if vim.go.operatorfunc:find("change") then
      operator = "c"
    elseif vim.go.operatorfunc:find("delete") then
      operator = "d"
    else
      vim.print("Unknown operatorfunc " .. vim.go.operatorfunc)
      return
    end
  end

  local scope = get_scope(row, count1)
  if not scope then
    return
  end

  local indent = scope.indent
  local indent_width = scope.indent_width
  local outer_start, outer_end = scope.outer_start, scope.outer_end
  local inner_start, inner_end = scope.inner_start, scope.inner_end

  local inner_lines
  if inner_start == inner_end then
    inner_lines = vim.api.nvim_buf_get_lines(buf, inner_start, inner_start + 1, false)
  else
    inner_lines = vim.api.nvim_buf_get_lines(buf, inner_start, inner_end + 1, false)
  end

  -- Yank the surrounding lines
  if operator == "y" then
    -- `vim.hl.on_yank` can't understand my selection here - so perform the
    -- highlight myself!
    local ns = vim.api.nvim_create_namespace("scope_border")
    vim.hl.range(buf, ns, "IncSearch", { outer_start, indent - indent_width }, { outer_start, -1 })
    vim.hl.range(buf, ns, "IncSearch", { outer_end, indent - indent_width }, { outer_end, -1 })
    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end, 150)

    local surrounding_lines = {
      unpack(vim.api.nvim_buf_get_lines(buf, outer_start, inner_start, false)),
      unpack(vim.api.nvim_buf_get_lines(buf, inner_end + 1, outer_end + 1, false)),
    }
    vim.fn.setreg(vim.v.register, table.concat(surrounding_lines, "\n"), "l")
    return
  end

  -- Comment the surrounding lines
  if operator == "g@" then
    require("vim._comment").toggle_lines(outer_start + 1, outer_start + 1)
    require("vim._comment").toggle_lines(outer_end + 1, outer_end + 1)
    return
  end

  if operator ~= "d" then
    vim.print("Unimplemented operator " .. operator .. "!")
    return
  end

  -- Deindent the lines we'll be keeping
  for i, line in ipairs(inner_lines) do
    local line_indent = vim.fn.indent(inner_start + i)
    inner_lines[i] = vim.text.indent(line_indent - indent_width, line, { expandtab = 1 })
  end

  -- Replace the full range with the deindented new version
  vim._with({ lockmarks = true }, function()
    vim.api.nvim_buf_set_lines(buf, outer_start, outer_end + 1, false, inner_lines)
  end)

  -- Deferring means this doesn't get accidentally deleted, since vim expects
  -- any cursor movement in operator mode to mean the operation you want to
  -- perform
  vim.defer_fn(function()
    local cursor_dedent = {
      math.max(1, row - (inner_start - outer_start)),
      math.max(0, col - indent_width),
    }
    vim.api.nvim_win_set_cursor(win, cursor_dedent)
  end, 1)
end
