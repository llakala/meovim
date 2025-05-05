vim.lsp.inlay_hint.enable(true)
local Snacks = require("snacks")

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

-- Custom formatting for diagnostics, to only show the diagnostic and the filename
local format_function = function(item, picker)
  local ret = {}
  local diag = item.item
  if item.severity then
    vim.list_extend(ret, Snacks.picker.format.severity(item, picker))
  end

  local message = diag.message
  ret[#ret + 1] = { message }
  Snacks.picker.highlight.markdown(ret)
  ret[#ret + 1] = { " | " }

  vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
  return ret
end

nnoremap("<leader>r", vim.lsp.buf.rename)
noremap("<leader>h", vim.lsp.buf.hover) -- h for help/hover

-- Mode independent - will show code actions on selection if
-- in visual mode
noremap("<leader>a", vim.lsp.buf.code_action)

noremap("<leader>d", function()
  vim.diagnostic.open_float() -- d for diagnostics
end)

-- i for implementation
nnoremap("<leader>i", function()
  Snacks.picker.lsp_definitions({
    auto_confirm = false,
    win = snacks_new_tab,
  })
end)

-- u for usage
nnoremap("<leader>u", function()
  Snacks.picker.lsp_references({
    auto_confirm = false,
    win = snacks_new_tab,
  })
end)

-- w for workspace. Shows workspace diagnostics, so you can see errors in other
-- files. Great for Gleam dev, since the Gleam LSP gets stuck if one file has errors.
-- Note that this doesn't work for all LSPs!
nnoremap("<leader>w", function()
  Snacks.picker.diagnostics({
    layout = "custom",
    format = format_function,

    win = snacks_new_tab,
  })
end)
