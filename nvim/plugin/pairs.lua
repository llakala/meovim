local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local ts_conds = require("nvim-autopairs.ts-conds")

npairs.setup()
-- print(vim.inspect(cond))

-- If there's punctuation after your cursor, and you type that character, don't do anything
local function replacePunctuation(punct)
  return Rule("", punct, "lua")
    :with_move(function(opts)
      return opts.char == punct
    end)
    :with_pair(function()
      return false
    end)
    :with_del(function()
      return false
    end)
    :with_cr(function()
      return false
    end)
    :use_key(punct)
end

-- From wiki: https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#insertion-with-surrounding-check
local function surrounding_spaces(a1, ins, a2, lang)
  return Rule(ins, ins, lang)
    :with_pair(function(opts)
      return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2) -- insert only works for #ins == 1 anyway
    end)
end

-- For testing, just run `:e` after sourcing on a given file
npairs.add_rules({
  Rule("/*", "*/", { "nix" }),

  replacePunctuation(","),
  replacePunctuation(";"),

  -- Allow delimiters before a dollar sign within math
  Rule("(", ")", { "typst" }):with_pair(cond.after_text("$")),
  Rule('"', '"', { "typst" }):with_pair(cond.after_text("$")),

  -- From:
  -- https://github.com/davinjason09/dotfiles/blob/3fb4eefe88d4811cab432c013013a8752cd5f86e/home/dot_config/nvim/after/ftplugin/typst.lua#L12
  Rule("$", "$", "typst")
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(ts_conds.is_not_ts_node("math"))
    :with_move(ts_conds.is_ts_node("math"))
    :replace_map_cr(function()
      return "<C-g>u<CR><ESC>O<Tab>"
    end),

  -- Only pair these when we're not in math mode
  Rule("*", "*", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(ts_conds.is_not_ts_node("math")),
  Rule("_", "_", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(ts_conds.is_not_ts_node("math")),
  Rule("<", ">", "typst")
    :with_pair(cond.not_before_regex("[%w]"))
    :with_pair(cond.not_after_regex("[%w]"))
    :with_pair(ts_conds.is_not_ts_node("math")),

  -- From wiki: https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#insertion-with-surrounding-check
  -- Interestingly, adding the single quote one breaks the {} one. No clue why!
  Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule("(", "),", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),

  surrounding_spaces("(", " ", ")"),
  surrounding_spaces("{", " ", "}"),
  surrounding_spaces("[", " ", "]"),
})
