-- Better `:set scrolloff` for keeping the cursor centered. `zz` has the
-- frustrating behavior of always clearing highlights, even if the current line
-- is already centered. This breaks my `fFtT` character highlighting. To fix
-- this, we only run `zz` if we actually changed lines.
--
-- Credit to
-- https://github.com/fsmiamoto/dotfiles/blob/21a9d9fc31be43f6d6daae796be543f841fe840f/common/.vimrc#L292
-- for the impl
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  desc = "Center cursor",
  callback = function(args)
    local curr_line = vim.fn.line(".")
    local prev_line = vim.b[args.buf].prev_line

    -- Whenever we open a buffer, we'll always start at line 1 - even if we open
    -- at a specific line, nvim still starts at line 1, it just moves you after
    -- the buffer is loaded. This means that if prev isn't set, we must be at
    -- line 1!
    if prev_line == nil then
      prev_line = 1
    end

    if prev_line ~= curr_line then
      vim.api.nvim_command("normal! zz")
      vim.b[args.buf].prev_line = curr_line
    end
  end,
})
