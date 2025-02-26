vim.api.nvim_create_user_command("Allman", function()
  vim.cmd[[:%s/\(\S\)\s*\([\[{(]\)$/\=submatch(1) . "\r" . matchstr(getline("."),'^\s*') . submatch(2)/ge]]
end, {})

cabbrev("alm", "Allman")
