{ pkgs }:
let
  inherit (pkgs) callPackage;
in {
  # Custom plugins
  fFtT-highlights-nvim = callPackage ./startPlugins/fFtT-highlights-nvim.nix {};
  lazydev-nvim = callPackage ./startPlugins/lazydev-nvim.nix {};
  oil-nvim = callPackage ./startPlugins/oil-nvim.nix {};

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
    # Neat features
    colorful-menu-nvim # Show completion types in color
    cutlass-nvim
    luasnip
    nvim-highlight-colors # Highlight hex codes
    snacks-nvim
    tiny-inline-diagnostic-nvim # Better `virtual_lines` from nvim 0.11
    # mini-nvim stuff
    mini-ai
    mini-comment
    mini-extra # More textobjects for mini-ai
    mini-indentscope
    # Colorschemes
    onedarkpro-nvim
    tokyonight-nvim
    # Filetype-specific
    # Dependencies
    nvim-web-devicons
    ;
}
