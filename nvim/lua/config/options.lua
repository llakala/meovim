o = vim.opt
g = vim.g -- Global variables

o.termguicolors = true

o.clipboard = "unnamed"
o.undofile = true -- Persistent undo
o.mouse = "" -- Disable mouse
o.hidden = false -- Some people swear by it, but I want closing tabs to actually close them
o.shiftround = true -- Round to the nearest indentation level when using `<` and `>`

o.cursorline = true
o.hlsearch = true -- Highlight search matches
o.number = true
o.breakindent = true -- Continue indented wrapped line at same level
o.laststatus = 3 -- Only one statusline, for better separator between horizontal splits
o.signcolumn = "yes"

o.ignorecase = true
o.smartcase = true

vim.cmd('filetype plugin indent on')
o.autoindent = false
o.cindent = false -- Smarter than smartindent
o.smartindent = false

g.loaded_matchit = 1 -- Lets us remap `%`

o.expandtab = true -- spaces as tab
o.tabstop = 2 -- 2 spaces for tabs
o.shiftwidth = 0 -- Reuse value of tabstop

-- Timeout isn't intuitive. We want it for `a` in visual mode, but that's a
-- PR for another day.
o.timeout = false

o.smoothscroll = true -- Shows a continuation `>>>` when wrapping line is cut off

o.backup = false
o.writebackup = false

g.mapleader = " "
