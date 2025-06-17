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
