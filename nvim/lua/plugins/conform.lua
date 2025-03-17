require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = function(bufnr)
    -- Be sure to use `vim.b`, not anything else like `vim.o`
    if vim.b[bufnr].disable_autoformat then
      return nil
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)

    -- Where I store random cloned git repos
    -- I probably shouldn't be auto-formatting codebases that aren't mine
    if bufname:match("/Documents/repos/*") then
      return nil
    end

    -- Calls conform.format(). We put our options in default_format_opts
    -- above, so they're applied when calling :fmt too
    return {}
  end,
})

vim.api.nvim_create_user_command("Fmt", function(args)
  local range = nil

  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  require("conform").format({ range = range })
end, { range = true })

-- Fine, I'm not supposed to make custom commands that are lowercase
-- I'll just abbreviate it. Happy?
-- Called when auto-format is disabled for a language or folder,
-- but we want to format it anyways
cabbrev("fmt", "Fmt")
