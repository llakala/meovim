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
      rev = "fc7e5cf6c93fef08effc183087a2c8cc9bf0d75a";
      hash = "sha256-uWhrGAwQ2nnAkyJ46qGkYxJ5K1jtyUIQOAVu3yTlquk=";
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
