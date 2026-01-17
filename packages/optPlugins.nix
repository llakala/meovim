{ pkgs }:
let
  inherit (pkgs) callPackage;
in {
  vim-nix = callPackage ./optPlugins/vim-nix.nix {};

  inherit (pkgs.vimPlugins)
    helpview-nvim
    typst-preview-nvim
    nvim-jdtls
    markdown-preview-nvim
    ;
}
