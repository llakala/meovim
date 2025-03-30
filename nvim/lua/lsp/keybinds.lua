nnoremap("<leader>r", vim.lsp.buf.rename)
noremap("<leader>h", vim.lsp.buf.hover) -- h for help/hover

-- Mode independent - will show code actions on selection if
-- in visual mode
noremap("<leader>a", vim.lsp.buf.code_action)

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

noremap("<leader>d", function()
  vim.diagnostic.open_float() -- d for diagnostics
end)

local cfg = {
  -- Autoconfirm would be nice, but it makes it open in the current
  -- buffer, which I don't want. If only snacks followed switchbuf!
  auto_confirm = false,

  -- I use mnw for Neovim, which provies a wonderful feature that lets
  -- me hot-reload the config, while keeping it declarative as a Nix
  -- package. However, doing this means that you get duplicate code
  -- stored in the `.direnv` folder, which lsps can find and assume
  -- is actual code. We filter out anything in `.direnv` or `/nix/store`,
  -- as no actual code should be stored there. The `.direnv` block is
  -- further down, since sometimes we won't be in a git repo.
  filter = {
    paths = {
      ["/nix/store"] = false,
    },
  },

  -- Open files in new tab
  win = snacks_new_tab
}

-- Don't make `.direnv` files searchable. We need to gate this behind a
-- condition to prevent issues where if we're not in a git repo, `get_root`
-- returns null, and lua freaks.
if Snacks.git.get_root() ~= nil then
  cfg.filter.paths[Snacks.git.get_root() .. "/.direnv"] = false
end

-- i for implementation
nnoremap("<leader>i", function()
  Snacks.picker.lsp_definitions(cfg)
end)

-- u for usage
nnoremap("<leader>u", function()
  Snacks.picker.lsp_references(cfg)
end)
