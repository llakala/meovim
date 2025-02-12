vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)

local cmpmap = require("cmp").mapping
-- init.lua: setup nvim-cmp
require("cmp").setup({
    snippet = {
        -- Exclusive to LuaSnip, check nvim-cmp documentation for usage with a different snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    mapping = {
					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<Enter>"] = cmpmap.confirm({ select = true }),

          ["<S-Tab>"] = cmpmap.select_prev_item(),
          ["<Tab>"] = cmpmap.select_next_item(),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})

require("lspconfig").nixd.setup({
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

