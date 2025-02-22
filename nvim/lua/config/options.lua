o = vim.opt
g = vim.g -- Global variables

o.termguicolors = true

o.clipboard = "unnamed"
o.undofile = true -- Persistent undo
o.mouse = "" -- Disable mouse

o.cursorline = true
o.hlsearch = true -- Highlight search matches
o.number = true
o.breakindent = true -- Continue indented wrapped line at same level
o.laststatus = 3 -- Only one statusline, for better separator between horizontal splits

o.ignorecase = true
o.smartcase = true

vim.cmd('filetype plugin indent on')
o.autoindent = true
o.cindent = true -- Smarter than smartindent
o.smartindent = false

o.expandtab = true -- spaces as tab
o.tabstop = 2 -- 2 spaces for tabs
o.shiftwidth = 0 -- Reuse value of tabstop

-- Show indentation
o.list = true
o.listchars = {leadmultispace = "│ "}

-- Timeout isn't intuitive. We want it for `a` in visual mode, but that's a
-- PR for another day.
o.timeout = false

o.smoothscroll = true -- Shows a continuation `>>>` when wrapping line is cut off

o.backup = false
o.writebackup = false

o.helpheight = 9999

g.mapleader = " "
