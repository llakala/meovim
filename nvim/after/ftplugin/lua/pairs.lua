local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")

local function replacePunctuation(lang, punct)
  return Rule("", punct, lang)
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

npairs.add_rules({
  -- From wiki:
  -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#insertion-with-surrounding-check
  -- For some reason, these only work with a specific order, I can't add one for
  -- parentheses, and if I tweak another rule very slightly, they stop working.
  -- I hate nvim-autopairs.
  Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule("'", "',", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),

  replacePunctuation("lua", ","),
})
