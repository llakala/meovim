return {
  "mini.ai",

  after = function()
    local mappings = {
      around = "a",
      inside = "i",
      around_next = "an",
      around_last = "al",
      inside_next = "in",
      inside_last = "il",
      goto_left = "g[",
      goto_right = "g]",
    }

    require("mini.ai").setup({
      mappings = mappings,
    })

    -- Don't populate which-key. We won't see these when timeout is off anyways,
    -- but it's good to behave.
    require("which-key").add({
      { "in", mode = "o", hidden = true },
      { "il", mode = "o", hidden = true },

      { "an", mode = "o", hidden = true },
      { "al", mode = "o", hidden = true },
    })
  end,
}
