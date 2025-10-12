local Yazi = require("yazi")

Yazi.setup({
  open_for_directories = true,
})

-- Often needed to add/delete a file, so it gets to be under `z`, which is easy
-- to reach
nnoremap("<leader>z", Yazi.yazi, { desc = "Open Yazi from current file" })

-- Most of the time, you don't want this, and instead should be working through
-- fzf-lua - so we map it to `y` which is difficult to reach.
nnoremap("<leader>y", function()
  Yazi.yazi({}, vim.uv.cwd())
end, { desc = "Open Yazi from project root" })
