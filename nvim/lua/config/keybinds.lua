-- Create a map with noremap set to true
local function mkNoremap(mode, key, map, opts)
  opts = opts or {}

  -- Merge the passed opts with the base ones. Using non-recursive tbl_extend.
  -- If you need recursion, change it!
  base_opts = { noremap = true, silent = true }
  opts = vim.tbl_extend("force", base_opts, opts)

  vim.keymap.set(mode, key, map, opts)
end

function nnoremap(key, map, opts)
  mkNoremap("n", key, map, opts)
end

function vnoremap(key, map, opts)
  mkNoremap("x", key, map, opts)
end

function inoremap(key, map, opts)
  mkNoremap("i", key, map, opts)
end

function onoremap(key, map, opts)
  mkNoremap("o", key, map, opts)
end

function bufmap(lhs, rhs, desc)
  desc = desc or ""

  -- Hardcoded to use normal mode for now - can add alternates when necessary
  vim.keymap.set("n", lhs, rhs, {
    buffer = true,
    noremap = false,
    silent = true,
    desc = desc,
  })
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

-- Tab management
nnoremap("th", ":tabprev<CR>", { desc = "Next tab" })
nnoremap("tl", ":tabnext<CR>", { desc = "Previous tab" })

nnoremap("tj", ":-tabmove<CR>", { desc = "Move tab left" })
nnoremap("tk", ":+tabmove<CR>", { desc = "Move tab right" })

nnoremap("td", ":quit<CR>", { desc = "Delete tab" })
nnoremap("tD", ":quit!<CR>", { desc = "Delete tab without saving" })
