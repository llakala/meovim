{ pkgs, neovimPlugins, lib }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    # Basic essentials
    nvim-treesitter.withAllGrammars
    nvim-lspconfig

    # Features
    nvim-autopairs
    vim-textobj-user
    yazi-nvim
    auto-session

    # Pretty
    rainbow-delimiters-nvim
    nvim-highlight-colors

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

  # Check https://github.com/NixNeovim/NixNeovimPlugins/blob/main/plugins.md
  extraPlugins = with neovimPlugins.packages.${pkgs.system};
  [
    onedarkpro-nvim
    tokyonight-nvim
  ];

  customPlugins = import ./custom.nix { inherit pkgs lib; };

in pkgsPlugins ++ extraPlugins ++ customPlugins
