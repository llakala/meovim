{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    yazi-nvim
    conform-nvim
    nvim-autopairs

    indent-blankline-nvim # Same as `indent-blankline-nvim-lua`
    gitsigns-nvim
    rainbow-delimiters-nvim
  ];
in
pkgsPlugins
