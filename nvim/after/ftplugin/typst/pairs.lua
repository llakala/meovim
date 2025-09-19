local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local ts_conds = require("nvim-autopairs.ts-conds")

-- Check recursively whether we're in math mode, rather than just assuming the
-- current scope is correct (we could be within a function or parentheses).
-- Referenced from
-- 1: https://github.com/CaptainKills/dotfiles/blob/20d7d30f8507280795f5f14014752b40f7c7eff0/nvim/luasnippets/typst.lua#L22
-- 2: https://github.com/ThetaOmega01/dotfiles/blob/a16df1873bb1f75e8bee2d59fc4c1ea48e7fd252/.config/nvim/lua/snippets/typst.lua#L15
local is_in_math = function(_)
  local ts = require("nvim-treesitter.ts_utils")
  local node = ts.get_node_at_cursor()

  -- String within math mode shouldn't trigger snippets
  if node and node:type() == "string" then
    return false
  end

  while node do
    local type = node:type()
    if type == "math" then
      return true
    end
    node = node:parent()
  end

  return false
end

local not_in_math = function(_)
  return not is_in_math()
end

require("nvim-autopairs").add_rules({
  -- Allow delimiters before a dollar sign within math
  Rule("(", ")", { "typst" }):with_pair(cond.after_text("$")),
  Rule('"', '"', { "typst" }):with_pair(cond.after_text("$")),

  -- From:
  -- https://github.com/davinjason09/dotfiles/blob/3fb4eefe88d4811cab432c013013a8752cd5f86e/home/dot_config/nvim/after/ftplugin/typst.lua#L12
  Rule("$", "$", "typst")
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(ts_conds.is_not_ts_node("math"))
    :with_move(is_in_math)
    :replace_map_cr(function()
      return "<C-g>u<CR><ESC>O<Tab>"
    end),

  -- Only pair these when we're not in math mode
  Rule("*", "*", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(not_in_math),
  Rule("_", "_", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(not_in_math),
  Rule("<", ">", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(not_in_math),
})
