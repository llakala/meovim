local bfl = require("bufferline")
local tint = require("bufferline.colors").shade_color
local shading = -20

-- Shades the colors so they're less bright
local error_tinted = tint(colors.error, shading)
local warning_tinted = tint(colors.warning, shading)
local info_tinted = tint(colors.info, shading)
local hint_tinted = tint(colors.hint, shading)
local fg = colors.fg

bfl.setup({
  -- Show the highlight for the current diagnostic, but only on the actual
  -- symbol - not for the rest of the tab name. We need to set the
  -- `foo_selected` color, otherwise it will use the default and match the
  -- diagnostic's color.
  highlights = {
    error_selected = {
      fg = fg,
    },
    error_diagnostic_selected = {
      fg = colors.error,
    },
    error_diagnostic = {
      fg = error_tinted,
    },

    warning_selected = {
      fg = fg,
    },
    warning_diagnostic_selected = {
      fg = colors.warning,
    },
    warning_diagnostic = {
      fg = warning_tinted,
    },

    hint_selected = {
      fg = fg,
    },
    hint_diagnostic_selected = {
      fg = colors.hint,
    },
    hint_diagnostic = {
      fg = hint_tinted,
    },

    info_selected = {
      fg = fg,
    },
    info_diagnostic_selected = {
      fg = colors.info,
    },
    info_diagnostic = {
      fg = info_tinted,
    },
  },
  -- Yes, it's really under `options`. Crazy!
  options = {
    mode = "tabs",
    diagnostics = "nvim_lsp",
    diagnostics_update_on_event = true,

    diagnostics_indicator = function(_, _, diag)
      symbols = { " ", " ", " ", "󰌵" }
      occurrences = { diag.error, diag.warning, diag.hint, diag.info }

      local final = ""
      local i = 0

      -- Choose the icon with the highest precedence. Error > warning > hint >
      -- info.
      while final == "" and i <= 4 do
        if occurrences[i] ~= nil then
          final = symbols[i] .. occurrences[i]
        end

        i = i + 1
      end
      return final
    end,
  },
})
