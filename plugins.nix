{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    # Basic essentials
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    lazy-nvim

    # Features
    nvim-autopairs
    vim-textobj-user
    yazi-nvim
    auto-session
    snacks-nvim
    ts-comments-nvim
    conform-nvim
    tiny-inline-diagnostic-nvim

    # Pretty
    nvim-highlight-colors
    gitsigns-nvim
    indent-blankline-nvim # Same as `indent-blankline-nvim-lua`
    helpview-nvim
    markdown-preview-nvim

    # Completions
    blink-cmp

    # Snippets
    luasnip

    # Overhauls
    bufferline-nvim
    lualine-nvim
    lualine-lsp-progress

    # From mini.nvim
    mini-cursorword
    mini-trailspace
    mini-surround
    mini-indentscope

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
    colorful-menu-nvim
  ];

in pkgsPlugins ++ extraPlugins
