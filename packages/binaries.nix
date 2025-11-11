{ pkgs }:

with pkgs; [
  # Language servers
  nixd
  nil
  lua-language-server
  tinymist

  # Formatters
  stylua
]
