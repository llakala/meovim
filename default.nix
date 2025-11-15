{ pkgs, mnw }:

mnw.lib.wrap pkgs {
  appName = "nvim";
  neovim = pkgs.neovim-unwrapped;

  luaFiles = [
    ./init.lua
  ];

  plugins = {
    startAttrs = import ./packages/startPlugins.nix { inherit pkgs; };
    start = import ./packages/treesitter.nix { inherit pkgs; };
    optAttrs = import ./packages/optPlugins.nix { inherit pkgs; };
    dev.config = {
      pure = ./nvim;
      impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
    };
  };
  extraBinPath = import ./packages/binaries.nix { inherit pkgs; };
}
