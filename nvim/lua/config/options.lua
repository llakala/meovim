-- Improves startup time
-- We do it before everything so it can help us the most
vim.loader.enable()

-- Global variables
opt = vim.opt
g = vim.g
o = vim.o

opt.termguicolors = true

opt.clipboard = "unnamed"
opt.undofile = true -- Persistent undo

-- Enable mouse (but not in command mode). I try not to use it, but it's useful
-- for scrolling diagnostics
opt.mouse = "nva"

-- Some people swear by it, but I want closing tabs to actually close them
opt.hidden = false

-- Round to the nearest indentation level when using `<` and `>`
opt.shiftround = true

opt.cursorline = true
-- Highlights the line number of the cursorline
o.cursorlineopt = "both"

opt.hlsearch = true -- Highlight search matches
opt.number = true
opt.breakindent = true -- Continue indented wrapped line at same level
opt.signcolumn = "yes"

-- When jumping around, don't center the line, so the screen position doesn't change.
opt.jumpoptions = "stack,view"

opt.showmode = false -- Using lualine
opt.showcmd = false -- Shows when we press keypresses, which we don't need
opt.laststatus = 3 -- Only one statusline, for better separator between horizontal splits

-- Custom window title, only showing current filename
opt.title = true
vim.o.titlestring = "%t"

opt.ignorecase = true
opt.smartcase = true

vim.cmd("filetype plugin indent on")
opt.autoindent = true
opt.cindent = true -- Smarter than smartindent
opt.smartindent = false

-- Continue line comments in all languages. Without adding `ro`, it only seemed
-- to work in some languages. Also remove `t`, so our textwidth stuff doesn't
-- apply to it
opt.formatoptions = "cqjro/"
o.wrap = false
-- Auto-wrap comments (but not other stuff, thanks to the `t` changes above)
o.textwidth = 80

g.loaded_matchit = 1 -- Lets us remap `%`

opt.expandtab = true -- spaces as tab
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 0 -- Reuse value of tabstop

-- Timeout isn't intuitive. We want it for `a` in visual mode, but that's a
-- PR for another day.
opt.timeout = false

-- Open new buffers in new tabs. Helpful for quickfix stuff
opt.switchbuf = "useopen,usetab,newtab"

opt.smoothscroll = true -- Shows a continuation `>>>` when wrapping line is cut off

opt.backup = false
opt.writebackup = false

g.mapleader = " "

vim.o.winborder = "rounded"
