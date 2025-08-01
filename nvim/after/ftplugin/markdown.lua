o.wrap = true

require("nvim-surround").buffer_setup({
  surrounds = {
    ["c"] = {
      add = { { "", "```", "" }, { "", "```", "" } },
      find = "```.-```",

      -- From https://github.com/gen4438/dotfiles/blob/0822a4bc6d652bf3c7d03adc3020808861d448d1/dot_config/nvim/lua/plugins/vim-surround.lua#L57
      -- Slightly modified to preserve the wrapping lines
      delete = "^(```.-)()%\n.-(```)()$",
    },
  },
})
