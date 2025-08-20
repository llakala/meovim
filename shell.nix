let
  inputs = import ./other/inputs.nix;
  pkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
  nvim = import ./default.nix;
in pkgs.mkShellNoCC {
  packages = [ nvim.devMode ];
}
