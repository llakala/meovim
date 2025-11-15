{ pkgs }:
let
  inherit (pkgs) callPackage;
in {
  # Custom plugins
  vim-nix = callPackage ./startPlugins/vim-nix.nix {};
  fFtT-highlights-nvim = callPackage ./startPlugins/fFtT-highlights-nvim.nix {};
  lazydev-nvim = callPackage ./startPlugins/lazydev-nvim.nix {};

  inherit (pkgs.vimPlugins)
    # Essentials
    auto-session
    blink-cmp
    conform-nvim
    fzf-lua
    lualine-lsp-progress
    lualine-nvim
    lz-n
    nvim-autopairs
    nvim-lspconfig
    nvim-surround
    rainbow-delimiters-nvim
    oil-nvim
    # Neat features
    colorful-menu-nvim # Show completion types in color
    cutlass-nvim
    fugitive
    luasnip
    nvim-highlight-colors # Highlight hex codes
    snacks-nvim
    tiny-inline-diagnostic-nvim # Better `virtual_lines` from nvim 0.11
    ts-comments-nvim # Lets me have multiple comment strings for `gcc` action
    vim-rhubarb # Make `:GBrowse` from fugitive work with Github
    # mini-nvim stuff
    mini-ai
    mini-comment
    mini-extra # More textobjects for mini-ai
    mini-indentscope
    # Colorschemes
    onedarkpro-nvim
    tokyonight-nvim
    # Filetype-specific
    helpview-nvim
    markdown-preview-nvim
    nvim-jdtls
    typst-preview-nvim
    # Dependencies
    nvim-web-devicons
    ;
}
