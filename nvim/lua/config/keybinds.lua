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

-- Yank contents of given register
-- Some highlists:
-- y"% for current filename
-- y": for last command
-- y"/ for last search
-- y". for last inserted test
-- y"=sin(3.14) for your mathematical needs
nnoremap('y"', function()
  local prompt = vim.fn.getcharstr()
  local contents
  -- Run expression and evaluate it
  if prompt == "=" then
    local expr = vim.fn.input({ prompt = "=" })
    local unsplit_output = vim.fn.eval(expr)
    if type(unsplit_output) ~= "string" then
      contents = unsplit_output
    else
      local split_output = vim.fn.split(unsplit_output, "\n")
      contents = #split_output == 1 and split_output[1] or unsplit_output
    end
  else
    contents = vim.fn.keytrans(vim.fn.getreg(prompt))
  end
  vim.fn.setreg(vim.v.register, contents)
end)
