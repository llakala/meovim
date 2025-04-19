{ inputs ? import ./inputs.nix, system ? builtins.currentSystem }:

let
  lib = inputs.nixpkgs.lib;
  pkgs = inputs.nixpkgs.legacyPackages.${system};

  neovimPlugins = inputs.neovimPlugins;
  llakaLib = inputs.llakaLib.pureLib; # Don't need any impure functions

  myPlugins = llakaLib.collectDirectoryPackages
  {
    inherit pkgs;
    directory = ./plugins;
  };

  myPackages = llakaLib.collectDirectoryPackages
  {
    inherit pkgs;
    directory = ./packages;
  };

in inputs.mnw.lib.wrap pkgs
{
  appName = "nvim";

  neovim = pkgs.neovim-unwrapped;

  initLua =
  /* lua */
  ''
    require("config")
    require("plugins")
    require("lsp")
  '';

  devExcludedPlugins = lib.singleton ./nvim;

  # Absolute path needed
  devPluginPaths = lib.singleton "/home/emanresu/Documents/projects/meovim/nvim";

  plugins =
    import ./plugins.nix { inherit pkgs neovimPlugins; }
    ++ builtins.attrValues myPlugins;

  extraBinPath =
    import ./packages.nix { inherit pkgs; } ++ builtins.attrValues myPackages;
}
