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
