{ pkgs }:
let
  # We remove zoxide and ffmpeg as dependencies. zoxide being included means
  # yazi doesn't use the global zoxide database, while ffmpeg increases the
  # closure by 500MB, and I'm not using Yazi for video stuff.
  customYazi = pkgs.yazi.override {
    optionalDeps = with pkgs; [
      jq
      poppler-utils
      _7zz
      fd
      ripgrep
      fzf
      imagemagick
      chafa
      resvg
    ];
  };

  packages = with pkgs; [
    # Language servers
    nixd
    nil
    lua-language-server
    tinymist

    # Formatters
    stylua
  ];
in packages ++ [ customYazi ]
