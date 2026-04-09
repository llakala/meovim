{ pkgs }:
let
  inherit (pkgs) callPackage;
in {
  vim-nix = callPackage ./optPlugins/vim-nix.nix {};

  inherit (pkgs.vimPlugins)
    typst-preview-nvim
    nvim-jdtls
    markdown-preview-nvim
    vim-fugitive
    vim-rhubarb # Make `:GBrowse` from fugitive work with Github
    ;
}
