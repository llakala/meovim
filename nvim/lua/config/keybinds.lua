-- Create a map with noremap set to false
-- Need to also set remap to true for some binds to work
local function mkRemap(mode, key, map)
  vim.keymap.set(mode, key, map, { remap = true, noremap = false, silent = true })
end

-- Create a map with noremap set to true
local function mkNoremap(mode, key, map)
  vim.keymap.set(mode, key, map, { noremap = true, silent = true })
end


function map (key, map)
  mkRemap("", key, map)
end

function noremap (key, map)
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


-- System clipboard always
nnoremap("y", "v\"+y")
vnoremap("y", "\"+ygv") -- Bring back selection after copying
noremap("p", "\"+[P") -- Paste before
noremap("P", "\"+[p") -- Paste after

-- Have j and k navigate visual lines rather than logical ones
nmap("j", "gj")
nmap("k", "gk")
vmap("j", "gj")
vmap("k", "gk")

-- Move around without selecting at all
nnoremap("<A-e>", "e")
nnoremap("<A-b>", "b")
vnoremap("<A-e>", "<Esc>e")
vnoremap("<A-b>", "<Esc>b")

-- Move around, selecting one word at a time
nnoremap("e", "eviw")
nnoremap("b", "bviwo")
vnoremap("e", "<Esc>eviw")
vnoremap("b", "<Esc>bviwo")

-- Move around, continuing selection
nnoremap("E", "ve")
nnoremap("B", "vb")
vnoremap("E", "e")
vnoremap("B", "b")

vnoremap("i", "<Esc>`<i")
vnoremap("a", "<Esc>`>a")

-- Helix-style match-in-word and match-around-word
nnoremap("mi", "vi")
nnoremap("ma", "va")

noremap("d", "\"_x") -- Delete current character, and don't copy to clipboard
noremap("c", "\"_s") -- Change, and don't copy to clipboard

noremap("U", "<C-r>") -- Redo

-- Go to beginning/end of visual line
noremap("H", "g^")
noremap("L", "g$")

noremap("<", "<<")
noremap(">", ">>")

-- Don't deselect when indenting/unindenting multiple lines
vnoremap("<", "<gv")
vnoremap(">", ">gv")

nnoremap("%", "ggVG") -- Select entire file
noremap("gG","G") -- gG to go to end of file

-- Comment/uncomment lines, Neovim 0.10 feature
nmap("#", "gcc")
vmap("#", "gcgv")

-- Clear highlights on search when pressing <Esc> in normal mode
-- From kickstart
nnoremap("<Esc>", "<cmd>nohlsearch<CR>")

-- Helix-style. i<Esc> won't move the cursor at all, while a<Esc> will move the cursor
-- one to the right. I prefer this, as I use i more than a.
inoremap("<Esc>", "<Esc>l")
