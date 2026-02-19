require("conform").setup({
  -- Sometimes a formatter will fail. We should write to the file anyways
  notify_on_error = false,

  formatters_by_ft = {
    java = { "google-java-format" },
    nix = { "nixfmt" },
    lua = { "stylua" },
    cpp = { "clang_format" },
    c = { "clang_format" },

    python = {
      "ruff_fix",
      "ruff_organize_imports",
      "ruff_format",
    },
  },

  -- For gleam
  default_format_opts = {
    lsp_format = "fallback",
  },

  formatters = {
    ["google-java-format"] = {
      command = "google-java-format",
      args = { "--aosp", "-" },
    },
    ["tex-fmt"] = {
      prepend_args = { "--nowrap", "--tabsize", "4" },
    },
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
    clang_format = {
      prepend_args = {
        "--style={BasedOnStyle: LLVM, AllowShortFunctionsOnASingleLine: Empty}",
      },
    },
  },
  format_on_save = nil,

  format_after_save = function(bufnr)
    -- Be sure to use `vim.b`, not anything else like `vim.o`
    if vim.b[bufnr].disable_autoformat then
      return nil
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("/Documents/repos/*") or bufname:match("/Documents/classes/*") then
      return nil
    end

    -- Calls conform.format(). We put our options in default_format_opts
    -- above, so they're applied when calling :fmt too
    return { async = true }
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

  require("conform").format({ range = range, async = true })
end, { range = true })

-- Fine, I'm not supposed to make custom commands that are lowercase
-- I'll just abbreviate it. Happy?
-- Called when auto-format is disabled for a language or folder,
-- but we want to format it anyways
cabbrev("fmt", "Fmt")

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
