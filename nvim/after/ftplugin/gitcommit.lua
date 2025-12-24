-- `vim-rhubarb` gives me `:Gbrowse` to open a file in Github, which is
-- wonderful. But it also comes with some completion options that don't seem to
-- work with `blink-cmp`. So, for now, disable completion in these buffers. If I
-- ever try to add a blink plugin that gives me git completions and forget about
-- this, I'll probably be very confused. Sorry, future me!
vim.b.completion = false

-- Wrap all text, not just comments
vim.opt_local.formatoptions:append({ t = true })
