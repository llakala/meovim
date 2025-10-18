local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.add_rules({
  -- The space in `= ` is loadbearing here - without it, nix won't recognize us
  -- as being within an attrset for the first attr. We use my custom util
  -- function that recurses up the node tree, rather than just checking the
  -- current node
  Rule("= ", ";", "nix"):with_pair(function(_)
    Autopairs_utils.in_ts_group({ "binding_set", "attrset_expression" }, {})
  end),
})
