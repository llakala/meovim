{ pkgs }:

let
  nil = pkgs.callPackage ./binaries/nil.nix {};
in

with pkgs; [
  # Language servers
  lua-language-server
  tinymist
  nil

  # Formatters
  stylua
  nixfmt
]
