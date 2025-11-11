local oil = require("oil")

vim.b.search_char = nil
vim.b.searching_forward = nil
local search_first_char = function(forward, reuse_prompt)
  local prompt = nil
  if reuse_prompt then
    prompt = vim.b.search_char
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    prompt = vim.fn.getcharstr()
  end

  local range = {}
  if forward then
    range = {
      first = vim.fn.line(".") + 1,
      last = vim.fn.line("$"),
      step = 1,
    }
  else
    range = {
      first = vim.fn.line(".") - 1,
      last = 1,
      step = -1,
    }
  end

  for i = range.first, range.last, range.step do
    local entry = oil.get_entry_on_line(0, i)
    if entry == nil then
      vim.print("Null entry somehow!")
      return
    end
    local first_char = entry.name:sub(1, 1)
    if prompt == first_char then
      vim.fn.feedkeys(i .. "G")
      if not reuse_prompt then
        vim.b.search_char = prompt
        vim.b.searching_forward = forward
      end
      return
    end
  end
  vim.print("No results found")
end

local goto_next = function(forward)
  if vim.v.hlsearch then
    local char = forward and "n" or "N"
    vim.api.nvim_feedkeys(char, "n", true)
  end
  if vim.b.search_char == nil or vim.b.searching_forward == nil then
    vim.print("No direction specified")
    return
  end
  if forward then
    search_first_char(vim.b.searching_forward, true)
  else
    search_first_char(not vim.b.searching_forward, true)
  end
end

oil.setup({
  keymaps = {
    H = "actions.parent",
    L = "actions.select",
    J = "j",
    K = "k",
    ["<C-h>"] = "actions.parent",
    ["<C-l>"] = "actions.select",
    ["<C-j>"] = "j",
    ["<C-k>"] = "k",
    f = {
      function()
        search_first_char(true, false)
      end,
      mode = "n",
    },
    F = {
      function()
        search_first_char(false, false)
      end,
      mode = "n",
    },
    n = function()
      goto_next(true)
    end,
    N = function()
      goto_next(false)
    end,
    ["<CR>"] = false,
    ["<Esc>"] = ":bd<CR>",
  },
  win_options = {
    signcolumn = "yes",
  },
  float = {
    padding = 10,
  },
})

nnoremap("<leader>e", oil.open_float)
nnoremap("<leader>E", ":Oil --float .<CR>")
