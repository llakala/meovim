-- Create a map with noremap set to true
local function mkNoremap(mode, key, map, desc)
  desc = desc or ""
  vim.keymap.set(mode, key, map, { noremap = true, silent = true, desc = desc })
end

function nnoremap(key, map, desc)
  mkNoremap("n", key, map, desc)
end

function vnoremap(key, map, desc)
  mkNoremap("x", key, map, desc)
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

nnoremap("U", "<C-r>") -- Redo
nnoremap("<A-u>", "U") -- In case you actually want this

nnoremap("H", "^")
vnoremap("H", "^")

-- If I'm going to the end of the line, I want the real end - if there's
-- trailing whitespace there, it sohuld be fixed anyways.
nnoremap("L", "$")
vnoremap("L", "$")

-- Clear highlights on search when pressing <Esc> in normal mode
-- From kickstart
nnoremap("<Esc>", "<cmd>nohlsearch<CR>")
