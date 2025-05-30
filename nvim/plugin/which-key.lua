local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 0,
})

local mappings = {
  preset = true,
  { "gq", desc = "Format" },
}
wk.add(mappings)
