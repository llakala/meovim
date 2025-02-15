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

o.timeoutlen = 50 -- Makes something like binding a to A in visual mode not take forever

g.mapleader = " "
