require("nvim-surround").setup({
  move_cursor = "sticky",

  keymaps = {
    normal = "sa",
    normal_cur_line = "sA",
    normal_cur = false,
    normal_line = false,

    delete = "sd",

    change = "sc",
    change_line = false,

    visual = "s",
    visual_line = false,

    insert = false,
    insert_line = false,
  },
})

-- This inherits from Visual by default, which is not very readable on my
-- colorscheme. We don't change Visual itself, because this color isn't very
-- good for comments. There's probably a way to make comments handle that
-- better, idk.
vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { bg = "#465172" })
