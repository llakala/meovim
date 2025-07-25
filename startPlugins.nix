{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins; [
    # Essentials
    blink-cmp
    bufferline-nvim
    conform-nvim
    lualine-nvim
    lualine-lsp-progress
    lz-n # Lazy loading, without package management
    nvim-autopairs
    nvim-lspconfig
    nvim-surround
    nvim-treesitter.withAllGrammars
    rainbow-delimiters-nvim
    yazi-nvim

    # Neat features
    colorful-menu-nvim # Show completion types in color
    fugitive
    vim-rhubarb # Make `:GBrowse` from fugitive work with Github
    luasnip
    nvim-highlight-colors # Highlight hex codes
    stay-centered-nvim # Always keep current line at center of screen
    snacks-nvim
    telescope-nvim
    telescope-ui-select-nvim
    ts-comments-nvim # Lets me have multiple comment strings for `gcc` action
    tiny-inline-diagnostic-nvim # Better `virtual_lines` from nvim 0.11
    which-key-nvim

    # mini-nvim stuff
    mini-comment
    mini-extra # More textobjects for mini-ai
    mini-indentscope
    mini-move

    # Colorschemes
    onedarkpro-nvim
    tokyonight-nvim

    # Filetype-specific
    helpview-nvim
    lazydev-nvim
    markdown-preview-nvim
    nvim-jdtls
    vimtex

    # Dependencies
    nvim-web-devicons # For bufferline
  ];

  # Check https://github.com/NixNeovim/NixNeovimPlugins/blob/main/plugins.md
  extraPlugins = with neovimPlugins.packages.${pkgs.system}; [
    # Not in nixpkgs yet
    cutlass-nvim # Seperate cut and delete binds
    hlargs-nvim # Highlight function arguments (in supported languages)
  ];

in pkgsPlugins ++ extraPlugins
