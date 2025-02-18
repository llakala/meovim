local o = vim.opt
local g = vim.g -- Global variables

o.clipboard = "unnamed"
o.undofile = true -- Persistent undo
o.mouse = "" -- Disable mouse

o.cursorline = true
o.hlsearch = true -- Highlight search matches
o.number = true

o.ignorecase = true
o.smartcase = true

o.autoindent = true
o.expandtab = true -- spaces as tab
o.tabstop = 2 -- 2 spaces for tabs
o.shiftwidth = 2 -- 2 spaces for tabs

-- Timeout isn't intuitive. We want it for `a` in visual mode, but that's a
-- PR for another day.
o.timeout = false

g.mapleader = " "
