function cabbrev(alias, expanded)
  local command = string.format("<c-r>=((getcmdtype()==':' && getcmdpos()==1) ? '%s' : '%s')<CR>", expanded, alias)
  vim.cmd.cnoreabbrev(alias, command)
end

-- i<Esc> won't move the cursor at all, while a<Esc> will move the cursor
-- one to the right. I prefer this, as I use i more than a. Helix-style!
vim.keymap.set("i", "<Esc>", "<Esc>l")

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

vim.keymap.set("n", "<leader><leader>", "<C-^>")
vim.keymap.set("n", "<A-w>", "<C-w>") -- I have <C-w> to close a tab in Kitty. Should get rid of that!

local ERROR = vim.diagnostic.severity.ERROR
vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = ERROR })
end, { desc = "Previous error" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = ERROR })
end, { desc = "Next error" })

-- Yank contents of given register
-- Some highlists:
-- y"% for current filename
-- y": for last command
-- y"/ for last search
-- y". for last inserted test
-- y"=sin(3.14) for your mathematical needs
vim.keymap.set("n", 'y"', function()
  local prompt = vim.fn.getcharstr()
  local contents
  -- Run expression and evaluate it
  if prompt == "=" then
    local expr = vim.fn.input({ prompt = "=", completion = "expression" })
    local unsplit_output = vim.fn.eval(expr)
    if type(unsplit_output) ~= "string" then
      contents = unsplit_output
    else
      local split_output = vim.split(unsplit_output, "\n")
      contents = #split_output == 1 and split_output[1] or unsplit_output
    end
  else
    contents = vim.fn.keytrans(vim.fn.getreg(prompt))
  end
  vim.print("Setting register '" .. vim.v.register .. "' to '" .. contents .. "'")
  vim.fn.setreg(vim.v.register, contents)
end)

-- Use blackhole register for all editing keymaps
for _, mode in pairs({ "x", "n" }) do
  for _, lhs in pairs({ "c", "C", "d", "D", "s", "S", "x", "X" }) do
    vim.keymap.set(mode, lhs, '"_' .. lhs, { silent = true })
  end
end

-- Opt in to copying to clipboard. Since timeout is disabled, this makes `dyip`
-- delete the current word and yank it
vim.keymap.set("n", "dy", "d", { desc = "Delete and yank" })
vim.keymap.set("n", "dY", "D", { desc = "Delete and yank rest of line" })
vim.keymap.set("v", "D", "d", { desc = "Delete and yank selection" })

vim.keymap.set("n", "cy", "c", { desc = "Change and yank" })
vim.keymap.set("n", "cY", "C", { desc = "Change and yank rest of line" })
vim.keymap.set("v", "C", "c", { desc = "Change and yank selection" })

-- q to close nvim entirely, d to close the current buffer. however, wq should
-- only write the current buffer. if you really want to write all buffers, use
-- :wa
cabbrev("d", "close")
cabbrev("wd", "w | close")
cabbrev("q", "qa")
cabbrev("wq", "w | qa")
cabbrev("qa", 'echoerr "just use :q"')
cabbrev("wqa", 'echoerr "just use :wq"')

-- By default, J's count isn't relative, so 2J doesn't perform J twice. I hate
-- this, so we fix it!
vim.keymap.set("n", "J", function()
  vim.cmd("normal! " .. vim.v.count + 1 .. "J")
end)
vim.keymap.set("n", "gJ", function()
  vim.cmd("normal! " .. vim.v.count + 1 .. "gJ")
end)

-- Same idea as above, so 3: runs the command on the next 3 lines
-- useful for substituting without needing visual mode
vim.keymap.set("n", ":", function()
  local expr
  if vim.v.count == 0 then
    expr = ":"
  else
    expr = ":.,.+" .. vim.v.count
  end
  vim.api.nvim_feedkeys(expr, "n", true)
end, { nowait = true })

-- Paste from selection clipboard
vim.keymap.set("n", "gp", '"*p')
vim.keymap.set("n", "gP", '"*P')

vim.keymap.set("n", "[u", "<Cmd>earlier 1f<CR>")
vim.keymap.set("n", "]u", "<Cmd>later 1f<CR>")
