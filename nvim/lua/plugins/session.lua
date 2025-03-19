require("auto-session").setup()

-- We save most things to session, but *not* buffers.
vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
