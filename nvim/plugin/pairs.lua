local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.setup()

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

Autopairs_utils = {}

-- Check recursively whether our current node is in some set of allowed nodes,
-- and not in some set of disallowed nodes.
-- Referenced from:
-- 1: https://github.com/CaptainKills/dotfiles/blob/20d7d30f8507280795f5f14014752b40f7c7eff0/nvim/luasnippets/typst.lua#L22
-- 2: https://github.com/ThetaOmega01/dotfiles/blob/a16df1873bb1f75e8bee2d59fc4c1ea48e7fd252/.config/nvim/lua/snippets/typst.lua#L15
Autopairs_utils.in_ts_group = function(allowed, disallowed)
  local ts = require("nvim-treesitter.ts_utils")
  local node = ts.get_node_at_cursor()

  while node do
    local type = node:type()

    -- Sometimes these are within math - if we see these before we see math,
    -- we're currently in them, and should exit early
    if vim.tbl_contains(disallowed, type) then
      return false
    end
    if vim.tbl_contains(allowed, type) then
      return true
    end

    node = node:parent()
  end

  return false
end

Autopairs_utils.replacePunctuation = function(lang, punct)
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
