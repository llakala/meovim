-- Improves startup time
-- We do it before everything so it can help us the most
vim.loader.enable()

-- Global variables. `vim.o` is preferred over `vim.opt`
g = vim.g
o = vim.o

-- Behavior

o.backup = false
o.writebackup = false
o.undofile = true -- Persistent undo

g.mapleader = " "

o.mouse = "nva" -- Enable mouse (but not in command mode).
o.clipboard = "unnamedplus"

-- Some people swear by it, but I want closing tabs to actually close them
o.hidden = false

-- Timeout isn't intuitive.
o.timeout = false

-- When jumping around, don't center the line, so the screen position doesn't
-- change.
o.jumpoptions = "stack,view"

-- Open new buffers in new tabs. Helpful for quickfix stuff
o.switchbuf = "useopen,usetab,newtab"

-- UI

o.winborder = "rounded"
o.termguicolors = true

o.cursorline = true
o.cursorlineopt = "both" -- Highlights the line number of the cursorline

o.number = true
o.relativenumber = true
o.signcolumn = "yes"

-- Shows a continuation `>>>` when wrapping line is cut off
o.smoothscroll = true

-- Custom window title, showing project cwd and current filename. Regex takes
-- the full cwd and takes everything after the last slash.
o.title = true
vim.o.titlestring = vim.fn.getcwd():match("([^/]+)$") .. ": %t"

-- Indentation/formatting

o.expandtab = true -- spaces as tab
o.tabstop = 2 -- 2 spaces for tabs
o.shiftwidth = 0 -- Reuse value of tabstop

-- If you need it, do `zi`
o.foldenable = false
o.foldmethod = "indent"

-- Round to the nearest indentation level when using `<` and `>`
o.shiftround = true

o.breakindent = true -- Continue indented wrapped line at same level

-- we don't turn on smartindent or cindent, and instead rely on filetype
-- indentation
o.autoindent = true

o.wrap = false

-- Search

o.ignorecase = true
o.smartcase = true
o.hlsearch = true -- Highlight search matches

-- Statusline

o.showmode = false -- Using lualine
o.showcmd = true -- Shows when we press keypresses, which we don't need

-- Only one statusline, for better separator between horizontal splits
o.laststatus = 3

-- Formatting

-- Continue line comments in all languages. Without adding `ro`, it only seemed
-- to work in some languages. Keep `t`, so text width also applies to something
-- like markdown
o.formatoptions = "tcqjro/"

-- Auto-wrap comments (but not other stuff, thanks to the `t` changes above)
o.textwidth = 80
