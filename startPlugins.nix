{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    # Basic essentials
    nvim-treesitter.withAllGrammars
    lz-n

    # I'm using native lsps, but having this enabled means the lsps just work,
    # since they'll listen to whatever lspconfig puts as the defaults
    nvim-lspconfig

    # Features
    nvim-autopairs
    yazi-nvim
    auto-session
    snacks-nvim
    ts-comments-nvim
    nvim-surround
    conform-nvim
    tiny-inline-diagnostic-nvim

    # Pretty
    nvim-highlight-colors
    gitsigns-nvim
    indent-blankline-nvim # Same as `indent-blankline-nvim-lua`
    helpview-nvim
    render-markdown-nvim
    markdown-preview-nvim
    stay-centered-nvim
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

    cutlass-nvim
    hlargs-nvim
  ];

in pkgsPlugins ++ extraPlugins
