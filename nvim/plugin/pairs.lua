local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local ts_conds = require("nvim-autopairs.ts-conds")

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

  -- From wiki: https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#insertion-with-surrounding-check
  -- Interestingly, adding the single quote one breaks the {} one. No clue why!
  Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule("(", "),", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),

  surrounding_spaces("(", " ", ")"),
  surrounding_spaces("{", " ", "}"),
  surrounding_spaces("[", " ", "]"),

  -- Copied from the nvim-autopairs source:
  -- https://github.com/windwp/nvim-autopairs/blob/23320e75953ac82e559c610bec5a90d9c6dfa743/lua/nvim-autopairs/rules/basic.lua#L44C8-L45C54
  -- It has this locked to specific languages, but I write codeblocks in all
  -- sorts of languages - and if I'm typing three `, I definitely want a
  -- codeblock.
  Rule("```", "```"):with_pair(cond.not_before_char("`", 3)),
})
