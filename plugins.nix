{ pkgs, neovimPlugins }:

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
    snacks-nvim
    ts-comments-nvim
    conform-nvim

    # Pretty
    nvim-highlight-colors
    gitsigns-nvim
    indent-blankline-nvim # Same as `indent-blankline-nvim-lua`
    helpview-nvim
    markdown-preview-nvim

    # Completion
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-async-path
    cmp-nvim-lsp-signature-help
    cmp-git
    lsp_signature-nvim

    # Snippets
    luasnip
    cmp_luasnip

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
  ];

in pkgsPlugins ++ extraPlugins
