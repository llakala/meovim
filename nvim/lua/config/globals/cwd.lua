Cwd = {}

-- Credit for git repo functions goes to:
-- https://github.com/mrcndz/dotfiles/blob/e1e24413961ee30db12d3a4fed88774d9b6f7406/nvim/lua/utils.lua
Cwd.in_git_repo = function()
  local cmd = "git rev-parse --is-inside-work-tree"
  return vim.fn.system(cmd) == "true\n"
end

Cwd.get_repo_root = function()
  local cmd = "git rev-parse --show-toplevel"
  local output = vim.fn.system(cmd)
  return vim.fn.trim(output)
end

Cwd.at_repo_root = function()
  return Cwd.get_repo_root() == vim.uv.cwd()
end

-- For consumption in other files
Cwd.get_project_cwd = function()
  if not Cwd.in_git_repo() then
    return vim.uv.cwd()
  end
  return Cwd.get_repo_root()
end
