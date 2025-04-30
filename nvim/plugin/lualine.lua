local lsp_progress = {
  "lsp_progress",
  display_components = {
    "lsp_client_name",
    "spinner",
  },
  colors = { use = true },
}
require("lualine").setup({
  sections = {
    lualine_b = { "branch", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { lsp_progress },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})
