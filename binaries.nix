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
    nil
    (jdt-language-server.override { jdk = pkgs.jdk_headless; }) # decreases closure
    lua-language-server
    fish-lsp
    gleam
    clang-tools
    typescript-language-server
    basedpyright
    ruff
    marksman
    tinymist

    # Formatters
    (google-java-format.override { jre = pkgs.jre_headless; })
    stylua
    tex-fmt # Couldn't get latexindent working

    # Plugin dependencies
    texliveBasic
    texlivePackages.latexmk
    texlivePackages.biber
  ];

in packages ++ [ customYazi ]
