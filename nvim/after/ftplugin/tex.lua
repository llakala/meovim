local wk = require("which-key")
wk.add({
  buffer = vim.api.nvim_get_current_buf(),
  {
    "<localleader>l",
    group = "+vimtex",
  },
  {
    mode = "n",
    { "<localleader>l", group = "+vimtex" },

    { "<localleader>lc", desc = "Clean" },
    { "<localleader>lC", desc = "Full Clean" },

    { "<localleader>le", desc = "Show Errors" },

    { "<localleader>lg", desc = "Show Status" },
    { "<localleader>lG", desc = "Show Status for All" },

    { "<localleader>li", desc = "Show Info" },
    { "<localleader>lI", desc = "Show Full Info" },

    { "<localleader>lk", desc = "Stop VimTeX" },
    { "<localleader>lK", desc = "Stop All VimTeX" },

    { "<localleader>ll", desc = "Compile" },
    { "<localleader>lL", desc = "Compile Selection" },

    { "<localleader>lt", desc = "Open Table of Contents" },
    { "<localleader>lT", desc = "Toggle Table of Contents" },

    { "<localleader>lv", desc = "View Compiled Document" },
    { "<localleader>lX", desc = "Reload VimTeX State" },

    { "<localleader>la", desc = "Show Context Menu" },
    { "<localleader>lm", desc = "Show Imaps" },
    { "<localleader>lo", desc = "Show Compiler Output" },
    { "<localleader>lq", desc = "Show VimTeX Log" },
    { "<localleader>lx", desc = "Reload VimTeX" },
    { "<localleader>ls", desc = "Toggle Main" },
  },
  {
    mode = "o",
    { "ic", desc = "Command (Latex)" },
    { "id", desc = "Delimiter (Latex)" },
    { "ie", desc = "Environment (Latex)" },
    { "im", desc = "Item (Latex)" },
    { "iP", desc = "Section (Latex)" },
    { "i$", desc = "Math environment (Latex)" },

    { "ac", desc = "Command (Latex)" },
    { "ad", desc = "Delimiter (Latex)" },
    { "ae", desc = "Environment (Latex)" },
    { "am", desc = "Item (Latex)" },
    { "aP", desc = "Section (Latex)" },
    { "a$", desc = "Math environment (Latex)" },
  },
  {
    mode = "n",
    { "[/", desc = "Start of a comment (Latex)" },
    { "]/", desc = "Start of a comment (Latex)" },

    { "[*", desc = "End of a comment (Latex)" },
    { "]*", desc = "End of a comment (Latex)" },

    { "[[", desc = "Start of a section (Latex)" },
    { "][", desc = "Start of a section (Latex)" },

    { "[]", desc = "End of a section (Latex)" },
    { "]]", desc = "End of a section (Latex)" },

    { "[m", desc = "\\begin (Latex)" },
    { "]m", desc = "\\begin (Latex)" },

    { "[M", desc = "\\end (Latex)" },
    { "]M", desc = "\\end (Latex)" },

    { "[n", desc = "Start of a math zone (Latex)" },
    { "]n", desc = "Start of a math zone (Latex)" },

    { "[N", desc = "End of a math zone (Latex)" },
    { "]N", desc = "End of a math zone (Latex)" },

    { "[r", desc = "\\begin{frame} (Latex)" },
    { "]r", desc = "\\begin{frame} (Latex)" },

    { "[R", desc = "\\end{frame} (Latex)" },
    { "]R", desc = "\\end{frame} (Latex)" },
  },
  {
    "<localleader>t",
    group = "+toggle-vimtex",
  },
  {
    "<localleader>ts",
    group = "+star",
  },
})

bufmap("<leader>tf", "<plug>(vimtex-cmd-toggle-frac)", "Fraction")
bufmap("<leader>tsc", "<plug>(vimtex-cmd-toggle-star)", "Star (command)")
bufmap("<leader>tse", "<plug>(vimtex-env-toggle-star)", "Star (environment)")
bufmap("<leader>te", "<plug>(vimtex-env-toggle)", "Environment")
bufmap("<leader>t$", "<plug>(vimtex-env-toggle-math)", "Math environment")
bufmap("<leader>tb", "<plug>(vimtex-env-toggle-break)", "Line break")
bufmap("<leader>td", "<plug>(vimtex-delim-toggle-modifier)", "Modifier")
bufmap("<leader>tD", "<plug>(vimtex-delim-toggle-modifier-reverse)", "Reverse modifier")

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    os.execute("pkill zathura")
  end,
})
