-- Use these globals in other files when needed
lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig = require("lspconfig")

require("lsp.keybinds")

require("lsp.lua")
require("lsp.gleam")
require("lsp.lua")
require("lsp.nix")
require("lsp.python")
