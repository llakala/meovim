local session = require("auto-session")

-- Credit for git repo functions goes to:
-- https://github.com/mrcndz/dotfiles/blob/e1e24413961ee30db12d3a4fed88774d9b6f7406/nvim/lua/utils.lua
function in_git_repo()
  local cmd = "git rev-parse --is-inside-work-tree"
  return vim.fn.system(cmd) == "true\n"
end

function get_repo_root()
  local cmd = "git rev-parse --show-toplevel"
  local output = vim.fn.system(cmd)
  return vim.fn.trim(output)
end

function at_repo_root()
  return get_repo_root() == vim.uv.cwd()
end

-- Is true when Neovim is called with no arguments or a folder argument. Helps
-- to ensure that sessions don't get improperly loaded when we should just be
-- opening a specific file. Credit goes to:
-- https://github.com/mike-jl/dotfiles/blob/953f6f1b40c4e3fe7642038d183384fd040e11ad/.config/nvim/lua/custom/plugins/auto-session.lua#L14
local arg_count = vim.fn.argc()
local first_arg = vim.fn.argv(1)
local passed_nothing_or_dir = arg_count == 0 or (arg_count == 1 and vim.fn.isdirectory(first_arg) == 1)

session.setup({
  -- Only create a new session if you're at the root of a git repo
  auto_create = at_repo_root,

  -- If you're in a subdirectory of a git repo, and neovim wasn't called with a
  -- specific file to be opened, activate the session for the repo's root.
  no_restore_cmds = {
    function()
      if in_git_repo() and not at_repo_root() and passed_nothing_or_dir then
        -- Neovim cd, not shell cd. Means when we exit Neovim,
        -- auto-session will consider us to be in the right
        -- directory.
        vim.api.nvim_cmd({
          cmd = "cd",
          args = { get_repo_root() },
        }, {})

        vim.api.nvim_cmd({
          cmd = "SessionRestore",
          args = { get_repo_root() },
        }, {})
      end
    end,
  },
})

-- We save most things to session, but don't save buffers and localoptions.
-- Buffers keep growing forever and lag the session - tabs are forever. And
-- localoptions are typically done for testing and shouldn't stay around.
vim.o.sessionoptions = "blank,curdir,help,tabpages,winsize,winpos,terminal"
