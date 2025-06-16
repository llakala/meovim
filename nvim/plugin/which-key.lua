local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 0,

  -- These cause lots of issues, since if you ever add something to the
  -- textobjects like mini.ai does, which-key will freak out that it's
  -- colliding. Hypothetically, you can fix this by turning on `vim.o.timeout`
  -- and making it really low, but then you can't use any keys that collide with
  -- a default vim bind (and I have that with `t`). And, of course, neovim
  -- doesn't let you actually unmap a vim-default keymap.
  --
  -- Instead of spending all our time fighting to make which-key work in
  -- operator mode, we just don't. Now, it works everywhere else! You can
  -- remember your textobjects yourself.
  plugins = {
    presets = {
      text_objects = false,
    },
  },
})

local mappings = {
  preset = true,
  { "gq", desc = "Format" },

  -- Don't let these populate operator mode
  { "%", mode = "o", hidden = true },
  { "g%", mode = "o", hidden = true },
}
wk.add(mappings)
