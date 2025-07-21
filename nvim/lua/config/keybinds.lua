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

function anoremap(key, map, opts)
  mkNoremap({ "n", "x", "o" }, key, map, opts)
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

-- i<Esc> won't move the cursor at all, while a<Esc> will move the cursor
-- one to the right. I prefer this, as I use i more than a. Helix-style!
inoremap("<Esc>", "<Esc>l")

-- Paste and format, Means we can paste something and it'll be properly
-- indented! Referenced from:
-- https://github.com/ku1ik/vim-pasta#why-is-it-better-than-nnoremap-p-pv-
nnoremap("p", "p`[v`]=")
nnoremap("P", "P`[v`]=")

nnoremap("U", "<C-r>") -- Redo
nnoremap("<A-u>", "U") -- In case you actually want this

-- Barely used, and easier to reach than ^. we keep H and L open, because
-- they're useful!
nnoremap("!", "^")
vnoremap("!", "^")

vim.keymap.set("n", "<Esc>", function()
  vim.cmd.nohlsearch()
  vim.cmd.echo()
  -- TODO: also clear highlights from fFtT-highlights
  -- See https://github.com/samiulsami/fFtT-highlights.nvim/issues/2
end, { silent = true, expr = true, desc = "Clear highlights and cmdline" })

-- These are the same as their forward counterparts, and typos shouldn't be
-- rewarded!
onoremap("i)", "<Nop>")
onoremap("a)", "<Nop>")
onoremap("i]", "<Nop>")
onoremap("a]", "<Nop>")
onoremap("i}", "<Nop>")
onoremap("a}", "<Nop>")

-- Tab management
nnoremap("th", ":tabprev<CR>", { desc = "Next tab" })
nnoremap("tl", ":tabnext<CR>", { desc = "Previous tab" })

nnoremap("tj", ":-tabmove<CR>", { desc = "Move tab left" })
nnoremap("tk", ":+tabmove<CR>", { desc = "Move tab right" })

nnoremap("td", ":quit<CR>", { desc = "Delete tab" })
nnoremap("tD", ":quit!<CR>", { desc = "Delete tab without saving" })

local ERROR = vim.diagnostic.severity.ERROR
nnoremap("[e", function()
  vim.diagnostic.jump({ count = -1, severity = ERROR })
end, { desc = "Previous error" })
nnoremap("]e", function()
  vim.diagnostic.jump({ count = 1, severity = ERROR })
end, { desc = "Next error" })

-- Supposedly `gq` is a keybind according to `:h v_gq`, but it doesn't seem to
-- exist anecdotally. I should really be using `gw`, since it preserves your
-- cursor location, but intuition is a son of a bitch.
vnoremap("gq", "gw", { desc = "Format" })
