Custom = {}

-- Check recursively whether our current node is in some set of allowed nodes,
-- and not in some set of disallowed nodes.
-- Referenced from:
-- 1: https://github.com/CaptainKills/dotfiles/blob/20d7d30f8507280795f5f14014752b40f7c7eff0/nvim/luasnippets/typst.lua#L22
-- 2: https://github.com/ThetaOmega01/dotfiles/blob/a16df1873bb1f75e8bee2d59fc4c1ea48e7fd252/.config/nvim/lua/snippets/typst.lua#L15
Custom.in_ts_group = function(allowed, disallowed)
  local ts = require("nvim-treesitter.ts_utils")
  local node = ts.get_node_at_cursor()

  while node do
    local type = node:type()

    -- Sometimes these are within math - if we see these before we see math,
    -- we're currently in them, and should exit early
    if vim.tbl_contains(disallowed, type) then
      return false
    end
    if vim.tbl_contains(allowed, type) then
      return true
    end

    node = node:parent()
  end

  return false
end
