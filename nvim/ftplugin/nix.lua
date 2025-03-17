-- We use cindent, which autoformats comments. We don't like that, and force it to stop.
o.cinkeys:remove("0#")

-- Custom option for disabling autoformat
-- Needs to be under `vim.b` to not affect other buffers
vim.b.disable_autoformat = true
