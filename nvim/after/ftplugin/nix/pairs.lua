local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")

npairs.add_rules({
  -- The space in `= ` is loadbearing here - without it, nix won't recognize us
  -- as being within an attrset for the first attr
  Rule("= ", ";", "nix"):with_pair(ts_conds.is_ts_node({ "binding_set", "attrset_expression" })),
})
