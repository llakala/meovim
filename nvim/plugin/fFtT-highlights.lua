require("fFtT-highlights"):setup({
  smart_motions = true,
  match_highlight = {
    -- If I go past a match, still show it, as long as it's in the closest 5.
    -- Means if I accidentally skip the match I wanted, it stays highlighted!
    persist_matches = 5,
  },
})

-- The `on_reset` logic is supposed to handle this,
-- but it seems to only work when you're in the MIDDLE of doing `f` or `t`.
-- `f<Esc>` runs these commands properly, but `fi<Esc>` doesn't. The second one
-- is what I really need for clearing search and cmdline, so this stays for now.
vim.keymap.set("n", "<Esc>", function()
  vim.cmd.nohlsearch()
  vim.cmd.echo()
end, { silent = true, expr = true, desc = "Clear highlights and cmdline" })
