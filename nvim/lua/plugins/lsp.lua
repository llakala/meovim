nnoremap("<leader>r", vim.lsp.buf.rename)
nnoremap("<leader>a", vim.lsp.buf.code_action)
nnoremap("<leader>d", vim.diagnostic.open_float)

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").nixd.setup({
  capabilities = lsp_capabilities,
  cmd =
  {
    "nixd",
    "--inlay-hints=false",
    "-semantic-tokens=true" -- NEEDED, makes syntax highlighting much better
  },
  -- settings.nixd =
  -- {
  --  nixpkgs.expr = "import <nixpkgs> { }",
  --   options.nixos.expr = "${hostOptions}",
  -- },
})

require("lspconfig").fish_lsp.setup({
  capabilities = lsp_capabilities,
})

require("lspconfig").lua_ls.setup({
  capabilities = lsp_capabilities,
  settings =
  {
    Lua =
    {
      diagnostics =
      {
        -- Neovim and Yazi globals
        globals = { "vim", "require", "ya", "cx", "Command" },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- https://github.com/nvim-lua/kickstart.nvim/issues/543#issuecomment-1859319206
        disable = { "missing-fields", "lowercase-global" },
      }
    }
  }
})

require("lazydev").setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

require("lspconfig").pylsp.setup({
  capabilities = lsp_capabilities,
  settings =
  {
    pylsp =
    {
      plugins =
      {
        pycodestyle = { enabled = true },
      }
    }
  }
})

require("lspconfig").gleam.setup({})
