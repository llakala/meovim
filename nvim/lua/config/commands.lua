-- Make brackets "Allman" style, where the opening bracket is on the next line
vim.api.nvim_create_user_command("Allman", function()
  --[[
  `\(\S\)\s*` matches non-whitespace followed by 1 or more whitespace.
  Lets us make sure we're matching for lines where the bracket isn't
  already on the next line. Allowing no whites
  `\([\[{(]\)$` matches `[`, `(`, and `{` at the end of the line.
  Now we get into the replacement. `\=` makes it treat this as
  an expression, so we can use fancy functions.
  `submatch(1)` brings back the matched text BEFORE the whitespace
  and the curly bracket. This is best shown with an example. Given
  the input `foo = {`, submatch(1) grabs the `=`. It does NOT match
  the whitespace. We have to do this because the nature of a
  replacement is that everything we grabbed gets removed - so we
  bring back that non-whitespace, but leave the whitespace, as it
  would become trailing if let into the capturing group.
  I didn't know this - `.` is a concat operator here. Cool! We place a
  newline, and go on.
  `matchstr(getline(".)` grabs the line. Not the current one that
  we've just gotten on to - the one which previously held the bracket.
  Why? I don't know!
  `,"^\s*"` is simple - it just repeats the whitespace of the previous
  line. This makes sure we're tabbed over the right amount. I'm sure
  there's a smart way to do this where you ask cindent for help, but
  I'm happy with this.
  Another concat, then we grab submatch(2), which is our bracket -
  whether it was {, (, or [.
  Finally, we end with options - `g`, to replace globally, and `e`,
  to not cause an error if we don't match anything.
  --]]
  vim.cmd([[:%s/\(\S\)\s\+\([\[{(]\)$/\=submatch(1) . "\r" . matchstr(getline("."),'^\s*') . submatch(2)/ge]])
end, {})

cabbrev("alm", "Allman")

-- Highlight current buffer's ansi escape codes
vim.api.nvim_create_user_command("TermHl", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Open a new tab, so when we reopen neovim, it will still have the old one
  vim.cmd("tabnew")
  local b = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value("buftype", "nofile", { buf = b })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = b })
  vim.api.nvim_set_option_value("swapfile", false, { buf = b })

  local chan = vim.api.nvim_open_term(b, {})
  vim.api.nvim_chan_send(chan, table.concat(lines, "\n"))
  vim.api.nvim_win_set_buf(0, b)
end, { desc = "Highlights ANSI termcodes in curbuf" })

-- Referenced from: https://www.reddit.com/r/neovim/comments/zhweuc/comment/izo9br1
vim.api.nvim_create_user_command("Redir", function(ctx)
  local exec = vim.api.nvim_exec2(":" .. ctx.args, {})
  local lines = vim.split(exec.output or "", "\n", { plain = true })

  vim.cmd("tabnew")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })
