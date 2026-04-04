local session = require("auto-session")
local Lib = require("auto-session.lib")

local arg_count = vim.fn.argc()

local settings = {
  -- Only create a new session if you're at the root of a git repo
  auto_create = vim.g.repo_root == vim.uv.cwd(),

  legacy_cmds = false,

  -- Still save the session if a help file fails to load. Some help files are
  -- from plugins that are loaded lazily, so if we reopen nvim, the helpfile
  -- won't be found. If we get that error, ignore it!
  restore_error_handler = function(error_msg)
    if error_msg and error_msg:find("E661") then
      return true
    end

    Lib.logger.error("Error restoring session, disabling auto save. Error message: \n" .. error_msg)
    return false
  end,

  no_restore_cmds = {
    function()
      if vim.g.repo_root ~= nil then
        vim.cmd.cd(vim.g.repo_root) -- Neovim cd for stuff like oil
        session.restore_session(vim.g.repo_root, { show_message = false })
      end
    end,
  },
}

if arg_count ~= 0 then
  settings.pre_restore_cmds = {
    function()
      startup_buffers = vim.api.nvim_list_bufs()
    end,
  }
  settings.preserve_buffer_on_restore = function(buffer)
    return vim.tbl_contains(startup_buffers, buffer)
  end
  vim.api.nvim_create_autocmd("SessionLoadPost", {
    callback = function()
      vim.api.nvim_win_set_buf(0, startup_buffers[1])
      vim.cmd.only()
    end,
  })
  settings.pre_save_cmds = {
    function()
      vim.cmd.bdelete(startup_buffers)
    end,
  }
end

session.setup(settings)

-- We save most things to session, but skip localoptions - they're typically
-- done for testing, and shouldn't stay around.
vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal"
