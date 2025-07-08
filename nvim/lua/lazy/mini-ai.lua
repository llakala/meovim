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
  -- These represents the beginning and the end of the commentstring. We'll
  -- choose one of them to use depending on the `ai_type`. commentstr is
  -- pre-escaped, so we don't need to bother with escaping it
  local start_index, end_index = line:find(commentstr)

  -- This represents the commentstr not being found in the line. Not sure how
  -- the end index could be nil if the start index wasn't, but better safe than
  -- sorry
  if start_index == nil or end_index == nil then
    return nil
  end

  -- Remove 1 from the start, and add 1 to the end, so the edges of the
  -- commentstring get included in the selection for whichever one we use.
  start_index = start_index - 1
  end_index = end_index + 1

  -- This is only for EOL comments, since mini.comment handles the other ones.
  -- Therefore, we can assume the comment will only be on one line, and can
  -- reuse the current line number. And no, there's no support for doc comments
  -- like /* */ - mini.comment doesn't support them, and I can only handle so
  -- much regex.
  local line_num = vim.fn.line(".")

  local from = {
    line = line_num,

    -- We include the comment in the selection if it was `ac`, but leave it out
    -- if it was `ic`
    col = ai_type == "a" and start_index or end_index,
  }

  local to = {
    line = line_num,

    -- Till the end of the line
    col = line:len(),
  }

  return { from = from, to = to }
end

return {
  "mini.ai",

  after = function()
    local MiniExtra = require("mini.extra")

    require("mini.ai").setup({
      custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),

        c = function(ai_type)
          local line = vim.api.nvim_get_current_line()

          -- Get the commentstring up until %s (including the space). Then,
          -- escape it for use in lua regex
          local commentstr = vim.pesc(vim.bo.commentstring:match("^(.*)%%s"))

          -- If the line has a comment that's only following whitespace, we can
          -- defer to mini.comment. We only have custom logic for EOL comments,
          -- since mini.comment doesn't implement logic for them
          if line:match("^%s*" .. commentstr) then
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
