-- we keep `vgc` and `gcip`, so you can comment/uncomment some range. The custom
-- textobject is only for modifying some commented range
vim.keymap.del("o", "gc")

require("mini.comment").setup({
  mappings = {
    comment = "",
    comment_line = "#",
    comment_visual = "#",

    -- We've homerolled a cooler comment textobject that gives separate behavior
    -- with `dic` vs `cic`, and also handles EOL comments!
    textobject = "",
  },
})

-- From https://github.com/echasnovski/mini.nvim/issues/1837
local function select_multiline_comment(operator)
  require("mini.comment").textobject()

  -- Default behavior of mini.comment removes the start of the comment, which is
  -- fine for most cases. We only keep going if we're doing anything other than
  -- `cic`
  -- TODO: is checking mode unnecessary here?
  if vim.fn.mode() ~= "V" or operator ~= "c" then
    return
  end

  -- Adjust selection to be charwise and not include edge comment parts
  local comment_left, comment_right = vim.bo.commentstring:match("^(.*)%%s(.*)$")
  if comment_left == nil then
    return
  end

  -- NOTE: this depends on implementation detail that `MiniComment.textobject`
  -- puts cursor on last line of comment block
  local from_line, to_line = vim.fn.line("v"), vim.fn.line(".")

  vim.fn.feedkeys("v", "nx")
  local to_col = vim.fn.getline(to_line):find(vim.pesc(comment_right) .. "%s*$")
  vim.api.nvim_win_set_cursor(0, { to_line, to_col - 2 })

  vim.fn.feedkeys("o", "nx")
  local _, from_col = vim.fn.getline(from_line):find("^%s*" .. vim.pesc(comment_left))
  vim.api.nvim_win_set_cursor(0, { from_line, from_col })
  vim.fn.feedkeys("o", "nx")
end

local function select_eol_comment(operator, line, commentstr)
  -- These represents the beginning and the end of the commentstring. We'll
  -- choose one of them to use depending on `operator`. commentstr is
  -- pre-escaped, so we don't need to bother with escaping it
  local comment_start, comment_end = line:find(commentstr)

  -- This represents the commentstr not being found in the line. Not sure how
  -- the end index could be nil if the start index wasn't, but better safe than
  -- sorry
  if comment_start == nil or comment_end == nil then
    return nil
  end

  -- This is only for EOL comments, since mini.comment handles the other ones.
  -- Therefore, we can assume the comment will only be on one line, and can
  -- reuse the current line number. And no, there's no support for doc comments
  -- like /* */ - mini.comment doesn't support them, and I can only handle so
  -- much regex.
  local line_num = vim.fn.line(".")

  local from_col = nil

  -- `dic` -> select from start of comment header to eol, include leading
  -- space if it exists
  --
  -- `vic` / `gwic` / `[^cd]ic` -> select from start of comment header to eol,
  -- don't include leading space
  --
  -- `cic` -> select from end of comment header to eol
  if operator == "c" then
    from_col = comment_end
  elseif operator == "d" then
    -- TODO: include multiple leading spaces, instead of just one
    local char_before_comment = line:sub(comment_start - 1, comment_start - 1)
    local offset = char_before_comment == " " and 2 or 1
    from_col = comment_start - offset
  else
    from_col = comment_start - 1
  end

  -- Till the end of the line, not including final newline
  local to_col = line:len() - 1

  -- exit visual mode if we're currently in it, so we can select a range properly
  -- \22 is <C-v>, \27 is <Esc>
  if vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode()) then
    vim.cmd("normal! \27")
  end

  vim.api.nvim_win_set_cursor(0, { line_num, from_col })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { line_num, to_col })
end

vim.keymap.set({ "x", "o" }, "ic", function()
  local operator = vim.fn.mode() == "v" and "v" or vim.v.operator
  local line = vim.api.nvim_get_current_line()

  -- Get the commentstring up until %s (including the space). Then, escape it
  -- for use in lua regex
  -- TODO: allow matching even if the space isn't there, so `--comment` is
  -- matched
  local commentstr = vim.pesc(vim.bo.commentstring:match("^(.*)%%s"))

  -- If the line has a comment that's only following whitespace, we can
  -- defer to mini.comment. We only have custom logic for EOL comments,
  -- since mini.comment doesn't implement logic for them
  if line:match("^%s*" .. commentstr) then
    select_multiline_comment(operator)
    return
  end

  select_eol_comment(operator, line, commentstr)
end)
