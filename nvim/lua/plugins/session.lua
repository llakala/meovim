require("auto-session").setup({
  -- Referenced from https://github.com/rmagatti/auto-session/issues/259#issuecomment-1812949343
  -- Helps with a corrupt session
  pre_save_cmds = { "NvimTreeClose" },
	save_extra_cmds = {
		"NvimTreeOpen"
	},
	post_restore_cmds = {
		"NvimTreeOpen"
	}
})
