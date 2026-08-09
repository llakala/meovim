{ pkgs, mnw }:

let
  inherit (pkgs) callPackage;
  wrapper = import ./wrapper.nix { inherit pkgs exports; };
  exports = {
    neovim = args: mnw.lib.wrap pkgs (wrapper args);
    sadin = callPackage ./other/sadin/package.nix { inherit (exports) gps; };
    gps = callPackage ./other/gps/package.nix { };
  };
in
exports
