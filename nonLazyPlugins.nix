{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    # Basic essentials
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    lz-n

    # Features
    auto-session
    vim-textobj-user
    snacks-nvim
    ts-comments-nvim
    tiny-inline-diagnostic-nvim

    # Pretty
    nvim-highlight-colors
    helpview-nvim
    markdown-preview-nvim
    rainbow-delimiters-nvim

    # Completions
    blink-cmp

    # Snippets
    luasnip

    # Overhauls
    bufferline-nvim
    lualine-nvim
    lualine-lsp-progress

    # From mini.nvim
    mini-trailspace
    mini-surround
    mini-indentscope

    # Dependencies
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
    colorful-menu-nvim

    nvim-web-devicons # For bufferline
  ];

in pkgsPlugins ++ extraPlugins
