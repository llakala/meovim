{ pkgs, mnw }:

let
  inherit (pkgs) callPackage;

  startPlugins = import ./startPlugins.nix { inherit pkgs; };
  optPlugins = import ./optPlugins.nix { inherit pkgs; };
  binaries = import ./binaries.nix { inherit pkgs; };

  customStartPlugins = {
    vim-nix = callPackage ./other/startPlugins/vim-nix.nix {};
    fFtT-highlights-nvim = callPackage ./other/startPlugins/fFtT-highlights-nvim.nix {};
    lazydev-nvim = callPackage ./other/startPlugins/lazydev-nvim.nix {};
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
