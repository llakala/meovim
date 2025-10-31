local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.add_rules({
  -- I tried going the treesitter route for this, but found there were always
  -- going to be edge cases. Sure, you might type `=` inside a string, but the
  -- chance of typing `= ` is much lower.
  Rule("= ", ";", "nix"):with_del(function(_)
    return false
  end),

  Autopairs_utils.replacePunctuation("nix", ";"),
})
