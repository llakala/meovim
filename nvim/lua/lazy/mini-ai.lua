-- From https://github.com/echasnovski/mini.nvim/issues/1837
local function select_multiline_comment(ai_type)
  -- Try selecting comment block as "whole lines"
  require("mini.comment").textobject()

  -- Default behavior of mini.comment removes the start of the comment. If we're
  -- doing `dac`, we're done!
  if vim.fn.mode() ~= "V" or ai_type == "a" then
    return
  end

  -- Adjust selection to be charwise and not include edge comment parts
  local comment_left, comment_right = vim.bo.commentstring:match("^(.*)%%s(.*)$")
  if comment_left == nil then
    return
  end

  -- NOTE: this depends on implementation detail that `textobject` puts
  -- cursor on last line of comment block
  local from_line, to_line = vim.fn.line("v"), vim.fn.line(".")

  vim.fn.feedkeys("v", "nx")
  local to_col = vim.fn.getline(to_line):find(vim.pesc(comment_right) .. "%s*$")
  vim.api.nvim_win_set_cursor(0, { to_line, to_col - 2 })

  vim.fn.feedkeys("o", "nx")
  local _, from_col = vim.fn.getline(from_line):find("^%s*" .. vim.pesc(comment_left))
  vim.api.nvim_win_set_cursor(0, { from_line, from_col })
  vim.fn.feedkeys("o", "nx")
end

local function select_eol_comment(ai_type, line, commentstr)
  local line_num = vim.fn.line(".")

  -- Whether to include the beginning commentstring in the match or not
  local get_start_col = nil
  local offset = -1
  if ai_type == "a" then
    get_start_col = vim.fn.match
    offset = 0
  else
    get_start_col = vim.fn.matchend
    offset = 1
  end

  local from = {
    line = line_num,

    col = get_start_col(line, commentstr) + offset,
  }

  local to = {
    line = line_num,

    -- Actually not inclusive problems - for some reason, this returns 1 more
    -- than the last index. Maybe for calculating string length? Anyways,
    -- subtract 1.
    col = vim.fn.col("$") - 1,
  }

  return { from = from, to = to }
end

return {
  "mini.ai",

  after = function()
    require("mini.ai").setup({
      custom_textobjects = {
        c = function(ai_type)
          local line = vim.api.nvim_get_current_line()

          -- Get the commentstring up until %s (including the space).
          local commentstr = vim.bo.commentstring:match("^(.*)%%s")

          -- Escape for use in regex. Did you know `-` has a meaning there? How
          -- awful!
          local escaped_commentstr = vim.pesc(commentstr)

          -- If the line has a comment that's only following whitespace, we can
          -- defer to mini.comment. We only have custom logic for EOL comments, since
          -- mini.comment doesn't implement logic for them
          if line:match("^%s*" .. escaped_commentstr) then
            select_multiline_comment(ai_type)
            return
          end

          return select_eol_comment(ai_type, line, commentstr)
        end,
      },
    })

    -- Don't populate which-key. We won't see these when timeout is off anyways,
    -- but it's good to behave.
    require("which-key").add({
      { "in", mode = "o", hidden = true },
      { "il", mode = "o", hidden = true },

      { "an", mode = "o", hidden = true },
      { "al", mode = "o", hidden = true },
    })
  end,
}
