-- If there's punctuation after your cursor, and you type that character, don't
-- do anything
local function replacePunctuation(punct)
  local Rule = require("nvim-autopairs.rule")
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

return {
  "nvim-autopairs",
  event = "InsertEnter",
  after = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    npairs.setup()

    -- For testing, just run `:e` after sourcing on a given file
    npairs.add_rules({
      Rule("/*", "*/", { "nix" }),

      replacePunctuation(","),
      replacePunctuation(";"),
    })
  end,
}
