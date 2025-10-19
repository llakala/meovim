{ pkgs, mnw }:

let
  inherit (pkgs) callPackage;

  startPlugins = import ./packages/startPlugins.nix { inherit pkgs; };
  optPlugins = import ./packages/optPlugins.nix { inherit pkgs; };
  binaries = import ./packages/binaries.nix { inherit pkgs; };

  customStartPlugins = {
    vim-nix = callPackage ./packages/startPlugins/vim-nix.nix {};
    fFtT-highlights-nvim = callPackage ./packages/startPlugins/fFtT-highlights-nvim.nix {};
    lazydev-nvim = callPackage ./packages/startPlugins/lazydev-nvim.nix {};
  };
  customOptPlugins = {};
  customBinaries = {};

in mnw.lib.wrap pkgs {
  appName = "nvim";
  neovim = pkgs.neovim-unwrapped;

  luaFiles = [
    ./init.lua
  ];

  plugins.start = startPlugins ++ builtins.attrValues customStartPlugins;
  plugins.opt = optPlugins ++ builtins.attrValues customOptPlugins;
  extraBinPath = binaries ++ builtins.attrValues customBinaries;

  plugins.dev.config = {
    pure = ./nvim;
    impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
  };
}
