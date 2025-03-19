nnoremap("<leader>r", vim.lsp.buf.rename)
noremap("<leader>h", vim.lsp.buf.hover) -- h for help/hover

-- Mode independent - will show code actions on selection if
-- in visual mode
noremap("<leader>a", vim.lsp.buf.code_action)

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = "rounded"
  }
})

noremap("<leader>d",
  function()
    vim.diagnostic.open_float() -- d for diagnostics
  end)

-- I use mnw for Neovim, which provies a wonderful feature that lets
-- me hot-reload the config, while keeping it declarative as a Nix
-- package. However, doing this means that you get duplicate code
-- stored in the `.direnv` folder, which lsps can find and assume
-- is actual code. We filter out anything in `.direnv` or `/nix/store`,
-- as no actual code should be stored there.
local function filter(items)
  if type(items) ~= "table" then
    return items
  end

  local filtered = {}

  for _, value in pairs(items) do
    -- `definition` uses `targetUri`, `references` uses `uri`
    -- Lua does some truthy magic here and assigns the right one
    local path = value.user_data.targetUri or value.user_data.uri

    if
        string.match(path, ".direnv") == nil and
        string.match(path, "/nix/store") == nil
    then
      table.insert(filtered, value)
    end
  end

  return filtered
end


local function handle_list(options)
  local items = options.items
  if #items > 1 then
    items = filter(items)
  end

  vim.fn.setqflist({}, ' ', { title = options.title, items = items, context = options.context })
  if #items == 0 then
    vim.cmd("echo 'no results'")
  elseif #items > 1 then
    vim.cmd("copen")
  else
    vim.cmd("cfirst")
  end
end

-- i for implementation
nnoremap("<leader>i",
  function()
    vim.lsp.buf.definition({ on_list = handle_list })
  end
)

-- u for usage
nnoremap("<leader>u",
  function()
    vim.lsp.buf.references(nil, { on_list = handle_list })
  end
)
