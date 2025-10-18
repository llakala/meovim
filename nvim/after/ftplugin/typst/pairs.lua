local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local ts_conds = require("nvim-autopairs.ts-conds")

local in_math = function(_)
  return Autopairs_utils.in_ts_group({ "math" }, { "content", "string", "code" })
end

local in_content = function(_)
  return Autopairs_utils.in_ts_group({ "content", "string" }, { "math", "code" })
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
    :with_move(in_math)
    :replace_map_cr(function()
      return "<C-g>u<CR><ESC>O<Tab>"
    end),

  -- Only pair these when we're writing markup
  Rule("*", "*", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(in_content),
  Rule("_", "_", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(in_content),
  Rule("<", ">", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(in_content),
})
