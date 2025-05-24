-- Create a map with noremap set to false
-- Need to also set remap to true for some binds to work
local function mkRemap(mode, key, map, desc)
  desc = desc or ""
  mode = mode or "n"
  vim.keymap.set(mode, key, map, { remap = true, noremap = false, silent = true, desc = desc })
end

-- Create a map with noremap set to true
local function mkNoremap(mode, key, map, desc)
  desc = desc or ""
  mode = mode or "n"
  vim.keymap.set(mode, key, map, { noremap = true, silent = true, desc = desc })
end

function nmap(key, map, desc)
  mkRemap("n", key, map, desc)
end

function vmap(key, map, desc)
  mkRemap("v", key, map, desc)
end

function imap(key, map, desc)
  mkRemap("i", key, map, desc)
end

function omap(key, map, desc)
  mkRemap("o", key, map, desc)
end

function nnoremap(key, map, desc)
  mkNoremap("n", key, map, desc)
end

function vnoremap(key, map, desc)
  mkNoremap("v", key, map, desc)
end

function inoremap(key, map, desc)
  mkNoremap("i", key, map, desc)
end

function onoremap(key, map, desc)
  mkNoremap("o", key, map, desc)
end

-- Paste and format, Means we can paste something and it'll be properly
-- indented! Referenced from:
-- https://github.com/ku1ik/vim-pasta#why-is-it-better-than-nnoremap-p-pv-
nnoremap("p", "p`[v`]=")
nnoremap("P", "P`[v`]=")

-- Comment/uncomment lines, Neovim 0.10 feature
nmap("#", "gcc")
vmap("#", "gcgv")

nnoremap("U", "<C-r>") -- Redo
nnoremap("<A-u>", "U") -- In case you actually want this

nnoremap("H", "^")
nnoremap("L", "g_")

-- Clear highlights on search when pressing <Esc> in normal mode
-- From kickstart
nnoremap("<Esc>", "<cmd>nohlsearch<CR>")
