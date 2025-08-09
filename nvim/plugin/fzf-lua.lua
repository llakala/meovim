vim.env.FZF_DEFAULT_OPTS = nil

require("fzf-lua").setup({
  -- Set up basic vim bindings. The equivalent of this SHOULD be set as an env
  -- variable, but this one works, and that one doesn't. who knows!
  keymap = {
    fzf = {
      true,
      ["start"] = "unbind(down,up)+hide-input",
      ["j"] = "down",
      ["k"] = "up",
      ["i"] = "show-input+unbind(i,j,k)",
      ["esc"] = 'transform:if [[ "$FZF_INPUT_STATE" = enabled ]]; then echo "hide-input+rebind(i,j,k)"; else echo abort; fi',
    },
  },
  actions = {
    files = {
      true,
      -- Open files in a new tab, rather than replacing current file
      ["enter"] = FzfLua.actions.file_tabedit,
    },
  },
})

FzfLua.register_ui_select()

-- Replace default LSP bindings with telescope equivalents
-- We don't mess with rename and code actions - snacks handles that
nnoremap("grr", FzfLua.lsp_references, { desc = "View usage(s)" })
nnoremap("gri", FzfLua.lsp_definitions, { desc = "View implementation" })
nnoremap("grt", FzfLua.lsp_typedefs, { desc = "View implementation" })
nnoremap("gO", FzfLua.lsp_document_symbols, { desc = "View implementation" })

-- Shows workspace diagnostics, so you can see errors in other files. Great for
-- Gleam dev, since the Gleam LSP gets stuck if one file has errors. Note that
-- this doesn't work for all LSPs!
nnoremap("grd", FzfLua.diagnostics_workspace, { desc = "Workspace diagnostics" })
