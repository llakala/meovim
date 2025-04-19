{
  system ? builtins.currentSystem,
  inputs ? import ./inputs.nix,
  nvim ? import ./default.nix { inherit system inputs; }
}:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
pkgs.mkShellNoCC
{
  packages = [ nvim.devMode ];
}
