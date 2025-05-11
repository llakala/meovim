-- Create a map with noremap set to false
-- Need to also set remap to true for some binds to work
local function mkRemap(mode, key, map)
  vim.keymap.set(mode, key, map, { remap = true, noremap = false, silent = true })
end

-- Create a map with noremap set to true
local function mkNoremap(mode, key, map)
  vim.keymap.set(mode, key, map, { noremap = true, silent = true })
end

function map(key, map)
  mkRemap("", key, map)
end

function noremap(key, map)
  mkNoremap("", key, map)
end

function nmap(key, map)
  mkRemap("n", key, map)
end

function vmap(key, map)
  mkRemap("v", key, map)
end

function imap(key, map)
  mkRemap("i", key, map)
end

function nnoremap(key, map)
  mkNoremap("n", key, map)
end

function vnoremap(key, map)
  mkNoremap("v", key, map)
end

function inoremap(key, map)
  mkNoremap("i", key, map)
end

-- Paste and format, then jump to where we were before the selection. Means we
-- can paste something and it'll be properly indented! I'd like to have it place
-- the cursor after, but that doesn't seem possible with the default marks.
noremap("p", "P`[v`]=`[")
noremap("P", "p`[v`]=`[")

-- Have j and k navigate visual lines rather than logical ones
nmap("j", "gj")
nmap("k", "gk")
vmap("j", "gj")
vmap("k", "gk")

noremap("<", "<<")
noremap(">", ">>")

-- Don't deselect when indenting/unindenting multiple lines
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- Comment/uncomment lines, Neovim 0.10 feature
nmap("#", "gcc")
vmap("#", "gcgv")

-- Clear highlights on search when pressing <Esc> in normal mode
-- From kickstart
nnoremap("<Esc>", "<cmd>nohlsearch<CR>")
