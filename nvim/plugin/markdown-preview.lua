-- Don't autostart markdown preview, However, once it is open, if we change
-- buffers, open the markdown file in the same file.
g.mkdp_auto_start = 0
g.mkdp_auto_close = 0
g.mkdp_combine_preview = 1

-- Opens markdown preview in a new Firefox window
vim.cmd([[
  function OpenMarkdownPreview(url)
    execute "silent ! firefox --new-window " . a:url
  endfunction
]])

vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
