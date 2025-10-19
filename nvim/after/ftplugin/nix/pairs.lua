local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.add_rules({
  -- Homerolled logic to auto-add semicolons. I didn't think most nodes even had
  -- children, but it turns out there are anonymous nodes that don't show up in
  -- `:InspectTree` until you type `a` - and these anonymous children seem to
  -- contain the wrapping syntax elements for your current node. All the
  -- existing setups for auto-semicolons had edge cases - but I haven't been
  -- able to find a place where this fails.
  Rule("=", ";", "nix"):with_pair(function(_)
    local node = vim.treesitter.get_node()
    if node == nil then
      return false
    end
    local child = node:child(0)
    if child == nil then
      return false
    end
    return vim.tbl_contains({ "{", "let" }, child:type())
  end),

  Autopairs_utils.replacePunctuation("nix", ";"),
})
