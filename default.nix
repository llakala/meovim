{ pkgs, mnw, small ? true }:

let
  args = { inherit pkgs; };
in
mnw.lib.wrap pkgs {
  appName = "nvim";
  neovim = pkgs.neovim-unwrapped;

  luaFiles = [
    ./init.lua
  ];

  plugins = {
    startAttrs = import ./packages/startPlugins.nix args;
    start = import ./packages/treesitter.nix args;
    optAttrs = import ./packages/optPlugins.nix args;
    dev.config = {
      pure = ./nvim;
      impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
    };
  };
  extraBinPath =
    import ./packages/binaries.nix args
    ++ (if small then [] else import ./packages/extraBinaries.nix args);
}
