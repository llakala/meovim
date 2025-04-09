-- Use these globals in other files when needed
lspconfig = require("lspconfig")

vim.lsp.inlay_hint.enable(true)

require("lsp.keybinds")

require("lsp.lua")
require("lsp.gleam")
require("lsp.lua")
require("lsp.nix")
require("lsp.python")
