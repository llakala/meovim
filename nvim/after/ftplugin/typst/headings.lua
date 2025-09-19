bufmap("<leader>ll", vim.cmd.TypstPreview)

local heading_query = [[
[
    (heading) @next-segment
]
]]

-- From https://github.com/max397574/typst-tools.nvim/blob/main/lua/typst-tools/utils.lua#L55
-- The plugin does a lot of other stuff we don't want, so we just pull the section binds in
bufmap("[[", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_number, col_number = cursor[1], cursor[2]

  local parser = vim.treesitter.get_parser(0, "typst")
  local tree = parser:parse()[1]

  if not tree or not tree:root() then
    return
  end

  local document_root = tree:root()

  local previous_match_query = vim.treesitter.query.parse("typst", heading_query)
  local final_node = nil

  for id, node in previous_match_query:iter_captures(document_root, 0, 0, line_number) do
    if previous_match_query.captures[id] == "next-segment" then
      local start_line, _, _, end_col = node:range()
      -- start_line is 0-based; increment by one so we can compare it to the 1-based line_number
      start_line = start_line + 1

      -- Skip node if it's inside a closed fold
      if not vim.tbl_contains({ -1, start_line }, vim.fn.foldclosed(start_line)) then
        goto continue
      end

      -- Find the last matching node that ends before the current cursor position.
      if start_line < line_number or (start_line == line_number and end_col < col_number) then
        final_node = node
      end
    end

    ::continue::
  end
  if final_node then
    ---@diagnostic disable-next-line: undefined-global
    require("nvim-treesitter.ts_utils").goto_node(final_node)
  end
end)

bufmap("]]", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_number, col_number = cursor[1], cursor[2]

  local parser = vim.treesitter.get_parser(0, "typst")
  local tree = parser:parse()[1]

  if not tree or not tree:root() then
    return
  end

  local document_root = tree:root()

  local next_match_query = vim.treesitter.query.parse("typst", heading_query)
  for id, node in next_match_query:iter_captures(document_root, 0, line_number - 1, -1) do
    if next_match_query.captures[id] == "next-segment" then
      local start_line, start_col = node:range()
      -- start_line is 0-based; increment by one so we can compare it to the 1-based line_number
      start_line = start_line + 1

      -- Skip node if it's inside a closed fold
      if not vim.tbl_contains({ -1, start_line }, vim.fn.foldclosed(start_line)) then
        goto continue
      end

      -- Find and go to the first matching node that starts after the current cursor position.
      if (start_line == line_number and start_col > col_number) or start_line > line_number then
        require("nvim-treesitter.ts_utils").goto_node(node)
        return
      end
    end

    ::continue::
  end
end)
