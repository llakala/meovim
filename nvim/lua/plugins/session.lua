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

session.setup({
  -- Only create a new session if you're at the root of a git repo
  auto_create = at_repo_root,

  -- If you're in a subdirectory of a git repo, activate the session for the repo's root
  no_restore_cmds = {
    function()
      if in_git_repo() and not at_repo_root() then
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

-- We save most things to session, but *not* buffers.
vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
