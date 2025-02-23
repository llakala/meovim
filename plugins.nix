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
    gitsigns-nvim

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

    # Dependencies
    nvim-web-devicons # For bufferline
    nvim-yarp # For wilder

    # Other
    nvim-jdtls
    lazydev-nvim
  ];

  # Check https://github.com/NixNeovim/NixNeovimPlugins/blob/main/plugins.md
  extraPlugins = with neovimPlugins.packages.${pkgs.system};
  [
    onedarkpro-nvim
    tokyonight-nvim
  ];

  customPlugins = import ./custom.nix { inherit pkgs lib; };

in pkgsPlugins ++ extraPlugins ++ customPlugins
