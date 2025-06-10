o.shiftwidth = 2
o.tabstop = 2

-- cindent is making lines without semicolons tab over on the next line
o.cindent = false
o.smartindent = true

-- Provides multiple comment strings, sorted longest-shortest for precedence
-- Note that this doesn't work unless you put it in `after/ftplugin`, not normal
-- `ftplugin`. Not sure why!
o.comments = ":////,:///,://"
