{ pkgs, neovimPlugins, lib }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    mini-move
    mini-cursorword
    mini-trailspace

    vim-textobj-user

    nvim-autopairs

    nvim-treesitter.withAllGrammars

    nvim-lspconfig

    nvim-cmp
    cmp-nvim-lsp

    luasnip
    cmp_luasnip

    nvim-jdtls
    rainbow-delimiters-nvim
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
