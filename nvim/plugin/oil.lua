local oil = require("oil")

vim.b.search_char = nil
vim.b.searching_forward = nil
local search_first_char = function(reuse_prompt)
  if reuse_prompt then
    prompt = vim.b.search_char
    if prompt == nil then
      vim.print("Can't repeat search without searching!")
      return
    end
  else
    prompt = vim.fn.getcharstr()
  end

  -- Wraparound search, starting from the current entry, so if you're searching
  -- for the current letter, and you don't find it, we wrap back around to the
  -- start.
  starting_line = vim.fn.line(".")
  num_iterations = vim.fn.line("$")
  for iteration_index = 0, num_iterations - 1 do
    local entry_index = 1 + math.fmod(starting_line + iteration_index, num_iterations)
    local entry = oil.get_entry_on_line(0, entry_index)

    if entry == nil then
      vim.print("Null entry somehow with index " .. entry_index)
      return
    end
    local first_char = entry.name:sub(1, 1)
    if prompt == first_char then
      vim.fn.feedkeys(entry_index .. "G")
      if not reuse_prompt then
        vim.b.search_char = prompt
      end
      return
    end
  end
  vim.print("No results found")
end

oil.setup({
  -- I have the ftplugin ignore the prompt, so we want to make sure nothing
  -- actually gets deleted by accident. In the future I'd like to try out using
  -- the git status of a file, and only prompt if you're deleting a file with
  -- uncommitted changes.
  delete_to_trash = true,

  keymaps = {
    H = "actions.parent",
    L = "actions.select",
    J = false,
    K = false,
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-j>"] = false,
    ["<C-k>"] = false,

    ["<C-f>"] = {
      function()
        search_first_char(false)
      end,
      mode = "n",
    },
    ["<C-;>"] = {
      function()
        search_first_char(true)
      end,
      mode = "n",
    },

    ["<CR>"] = false,
    ["<Esc>"] = {
      ":bd<CR>",
      silent = true,
    },
    ["<Tab>"] = "actions.preview",
    ["gs"] = {
      callback = function()
        sort_by_recent = not sort_by_recent
        if sort_by_recent then
          oil.set_sort({ { "mtime", "desc" } })
          oil.set_columns({
            { "icon" },
            { "mtime", highlight = "NonText", format = "%b %d" },
          })
        else
          oil.set_sort({
            { "type", "asc" },
            { "name", "asc" },
          })
          oil.set_columns({ "icon" })
        end
      end,
      nowait = true, -- Override the existing `gs` bind
    },
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
