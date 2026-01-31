{ pkgs, mnw, small ? false }:

let
  args = { inherit pkgs; };
in
mnw.lib.wrap pkgs {
  appName = "nvim";
  neovim = pkgs.neovim.unwrapped.overrideAttrs {
    version = "0.12.0";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "36db6ff2c128864840e2820491a2172d6b1b7e62";
      hash = "sha256-iD+eb82J3TrP5/KMjS4LZ7hTJOWMATTTAC5a94+BgiM=";
    };
    doInstallCheck = false;
  };

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
    ++ (
      if small then []
      else import ./packages/extraBinaries.nix args
    );
}
