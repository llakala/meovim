-- This requires special logic to not break my `fFtT` highlights. Neovim clears
-- hghlights on `zz`, even if the cursor doesn't end up moving. This means that
-- if I run `zz` on every movement, jumping with `f` in the current line will
-- clear the highlights.
--
-- To work around this, I detect whether our cursor is currently centered on the
-- screen, and only run `zz` if it's not. This is more difficult to do than
-- you'd expect - it's trivial if we're in the middle of a buffer and the window
-- height is odd, but the moment that's not true, you need extra logic.
--
-- Naturally, this is a hack, which would be better solved by many changes on
-- the Neovim side, including (but not limited to):
-- 1. Having a more specific CursorMoved autocmd, like CursorMovedV for vertical
-- movement
-- 2. Adding a parameter to the CursorMoved autocmd, which would provide the
-- previous and new cursor position. This would let us take a simple difference
-- for the lnum, and greatly decrease the footprint of this
-- 3. Smarter `zz` highlight clearing, where it doesn't clear highlights if you
-- remain in the same line
--
-- When I'm less swamped, I hope to create a Neovim issue for implementing #3,
-- as I consider it the sanest and easiest solution.
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  desc = "Center cursor",

  callback = function()
    -- You might wonder how bad this is for performance, since it's a lot of API
    -- calls. I had the same question, so I did some profiling, and it comes out
    -- to 0.03ms when we're already centered, and 0.10ms when we have to call
    -- `zz`, The execution time was so fast that I used `:sleep` to make sure
    -- that `reltime()` was actually giving an output in seconds!
    local window_start = vim.fn.line("w0")
    local window_end = vim.fn.line("w$")
    local current_line = vim.fn.line(".")
    local buffer_end = vim.fn.line("$")
    local winheight = vim.fn.winheight(0)
    local winradius = math.floor(winheight / 2)

    local distance_to_bottom = window_end - current_line
    local distance_to_start = current_line - window_start

    -- If the height is even, Neovim shows one extra line below the cursor.
    -- Round down, and pretend both heights are the same.
    if (winheight % 2) == 0 then
      distance_to_bottom = distance_to_bottom - 1
      winradius = winradius - 1
    end

    -- We can see the bottom of the buffer, and our current line is centered
    -- relative to the top of the window.
    local safe_at_bottom = window_end == buffer_end and distance_to_start == winradius

    -- We can see the top of the buffer, and are on the top half of the screen
    local safe_at_top = window_start == 1 and distance_to_start < winradius

    local safe_at_center = distance_to_start == distance_to_bottom and distance_to_bottom == winradius

    if safe_at_center or safe_at_top or safe_at_bottom then
      return
    end
    vim.api.nvim_command("normal! zz")
  end,
})
