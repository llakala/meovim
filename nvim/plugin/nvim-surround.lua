local cache = require("nvim-surround.cache")
local config = require("nvim-surround.config")

-- The defaults use ( for whitespace, and ) for no whitespace. Silly!
-- See https://github.com/kylechui/nvim-surround/issues/384
function create_surround(left, right, use_whitespace)
  local add = nil
  local delete = nil

  if use_whitespace == true then
    add = { left .. " ", " " .. right } or {}
    delete = "^(. ?)().-( ?.)()$"
  else
    add = { left, right }
    delete = "^(.)().-(.)()$"
  end

  return {
    add = add,
    delete = delete,
  }
end

vim.g.nvim_surround_no_normal_mappings = true

nnoremap("s", "<Plug>(nvim-surround-normal)")
nnoremap("ss", "<Plug>(nvim-surround-normal-cur)")
nnoremap("gs", "<Plug>(nvim-surround-normal-line)")
nnoremap("gss", "<Plug>(nvim-surround-normal-cur-line)")

vnoremap("s", "<Plug>(nvim-surround-visual)")
vnoremap("gs", "<Plug>(nvim-surround-visual-line)")

nnoremap("ds", "<Plug>(nvim-surround-delete)")
nnoremap("cs", "<Plug>(nvim-surround-change)")

require("nvim-surround").setup({
  move_cursor = "sticky",

  surrounds = {
    ["("] = create_surround("(", ")", false),
    [")"] = create_surround("(", ")", true),

    ["["] = create_surround("[", "]", false),
    ["]"] = create_surround("[", "]", true),

    ["{"] = create_surround("{", "}", false),
    ["}"] = create_surround("{", "}", true),

    ["<"] = create_surround("<", ">", false),
    [">"] = create_surround("<", ">", true),

    ["<CR>"] = {
      find = "\n(\n)().-\n(\n)()",
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
})

-- This inherits from Visual by default, which is not very readable on my
-- colorscheme. We don't change Visual itself, because this color isn't very
-- good for comments. There's probably a way to make comments handle that
-- better, idk.
vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { bg = "#465172" })
