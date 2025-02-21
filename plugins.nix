{ pkgs, neovimPlugins, lib }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
     # Basic essentials
    nvim-treesitter.withAllGrammars
    nvim-lspconfig

    # Features
    rainbow-delimiters-nvim
    nvim-autopairs
    vim-textobj-user
    yazi-nvim

    # Completion
    nvim-cmp
    cmp-nvim-lsp

    # Snippets
    luasnip
    cmp_luasnip

    # Overhauls
    bufferline-nvim

    # From mini.nvim
    mini-move
    mini-cursorword
    mini-trailspace
    mini-surround

    # Other
    nvim-jdtls
    nvim-web-devicons
  ];

  extraPlugins = with neovimPlugins.packages.${pkgs.system};
  [
    onedarkpro-nvim
  ];

  textobj-line = pkgs.vimUtils.buildVimPlugin
  {
    name = "vim-textobj-line";
    src = pkgs.fetchFromGitHub
    {
      owner = "kana";
      repo = "vim-textobj-line";
      rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
      hash = "sha256-k6kjmwNqmklVaCigMzBL7xpuMAezqT2G3ZcPtCp791Y=";
    };
  };

  customPlugins = lib.singleton textobj-line;

in pkgsPlugins ++ extraPlugins ++ customPlugins
