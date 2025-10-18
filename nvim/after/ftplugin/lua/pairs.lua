local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")

npairs.add_rules({
  -- From wiki:
  -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#insertion-with-surrounding-check
  -- For some reason, these only work with a specific order, I can't add one for
  -- parentheses, and if I tweak another rule very slightly, they stop working.
  -- I hate nvim-autopairs.
  Rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),
  Rule("'", "',", "lua"):with_pair(ts_conds.is_ts_node({ "table_constructor" })),

  Autopairs_utils.replacePunctuation("lua", ","),
})
