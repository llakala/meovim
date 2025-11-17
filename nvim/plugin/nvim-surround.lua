local cache = require("nvim-surround.cache")

local left_delete = "^(.)().-(.)()$"
local right_delete = "^(. ?)().-( ?.)()$"

require("nvim-surround").setup({
  move_cursor = "sticky",

  -- The defaults use ( for whitespace, and ) for no whitespace. Silly!
  -- See https://github.com/kylechui/nvim-surround/issues/384
  surrounds = {
    ["("] = {
      add = { "(", ")" },
      delete = left_delete,
    },
    [")"] = {
      add = { "( ", " )" },
      delete = right_delete,
    },
    ["["] = {
      add = { "[", "]" },
      delete = left_delete,
    },
    ["]"] = {
      add = { "[ ", " ]" },
      delete = right_delete,
    },
    ["{"] = {
      add = { "{", "}" },
      delete = left_delete,
    },
    ["}"] = {
      add = { "{ ", " }" },
      delete = right_delete,
    },
    ["<"] = {
      add = { "<", ">" },
      delete = left_delete,
    },
    [">"] = {
      add = { "< ", " >" },
      delete = right_delete,
    },

    -- codeblock! We add this for all languages, since I still use codeblocks in
    -- languages where they aren't a feature (like git commit descriptions)
    ["C"] = {
      add = { { "", "```", "" }, { "", "```", "" } },
      find = "```.-```",

      -- From https://github.com/gen4438/dotfiles/blob/0822a4bc6d652bf3c7d03adc3020808861d448d1/dot_config/nvim/lua/plugins/vim-surround.lua#L57
      -- Slightly modified to preserve the wrapping lines
      delete = "^(```.-)()%\n.-(```)()$",
    },

    -- Works with lines surrounding the current indentation level
    i = {
      delete = function()
        return Custom.get_indent_selections(true, cache.delete.count)
      end,
      change = {
        target = function()
          return Custom.get_indent_selections(false, cache.change.count)
        end,
      },
    },
  },

  keymaps = {
    insert = false,
    insert_line = false,

    normal = "s",
    normal_cur = "ss",
    normal_line = "gs",
    normal_cur_line = "gss",

    delete = "ds",

    change = "cs",
    change_line = false,

    visual = "s",
    visual_line = "gs",
  },
})

-- This inherits from Visual by default, which is not very readable on my
-- colorscheme. We don't change Visual itself, because this color isn't very
-- good for comments. There's probably a way to make comments handle that
-- better, idk.
vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { bg = "#465172" })
