return {
  { "vim-textobj-user" },

  {
    -- To find the name of this, I did:
    -- `nix build .#packages.x86_64-linux.default.builtConfigDir`
    -- and then went into the path:
    -- `./result/pack/mnw/opt`
    -- to figure out what thename of the plugin was. Of course, I only had to do
    -- that because I packaged this manually, so the derivation name was all
    -- weird. Still good to know about, though!
    "vimplugin-vim-textobj-line",

    -- Actually a meaningful change - saves 15ms!
    event = "DeferredUIEnter",

    after = function()
      vmap("al", "<Plug>(textobj-line-a)")
      vmap("il", "<Plug>(textobj-line-i)")

      -- No clue why this isn't working in lua
      -- Makes x select the current line without newlines
      vim.cmd("nmap x val")

      -- When selecting, x to increase selection by a line, X to decrease it
      -- The textobj stuff means we don't have visual-line, so we emulate it, while
      -- not selecting ending newlines
      vnoremap("x", "jg_")
      vnoremap("X", "kg_")

      -- Good idea, but breaks `d` when I'm in visual mode and want to
      -- delete something that isn't a line. TODO: come back to this when
      -- I have more neovim experience and can make a custom mode
      -- vnoremap("d", "$d")
    end,
  },
}
