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

nnoremap("U", "<C-r>", { desc = "Redo" })

nnoremap("<leader><leader>", "<C-^>")
nnoremap("<A-w>", "<C-w>") -- I have <C-w> to close a tab in Kitty. Should get rid of that!

local ERROR = vim.diagnostic.severity.ERROR
nnoremap("[e", function()
  vim.diagnostic.jump({ count = -1, severity = ERROR })
end, { desc = "Previous error" })
nnoremap("]e", function()
  vim.diagnostic.jump({ count = 1, severity = ERROR })
end, { desc = "Next error" })

-- Supposedly `gq` is a keybind in visual mode according to `:h v_gq`, but it
-- doesn't seem to exist anecdotally. I should really be using `gw`, since it
-- preserves your cursor location, but intuition is a son of a bitch.
vnoremap("gq", "gw", { desc = "Format" })

-- Custom binding that deletes the lines starting/ending an indentation level
vim.keymap.set("o", "I", Custom.delete_surrounding_indent)
