require("config.options")
require("config.keybinds")
require("config.lsp")
require("config.colorscheme")

Custom = {}
require("config.globals.cwd")
require("config.globals.in_ts_group")

require("config.autocmds.marks")
require("config.autocmds.yank")
require("config.autocmds.suspend")
require("config.autocmds.trailing")
require("config.autocmds.scrolloff")

require("config.commands.allman")
require("config.commands.redir")
require("config.commands.termhl")
require("config.commands.rm")
require("config.commands.deallman")
require("config.commands.macros")
