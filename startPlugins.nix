{ pkgs }:

let
  nixpkgsPlugins = with pkgs.vimPlugins; [
    # Essentials
    auto-session
    blink-cmp
    conform-nvim
    fzf-lua
    lualine-nvim
    lualine-lsp-progress
    lz-n # Lazy loading, without package management
    nvim-autopairs
    nvim-lspconfig
    nvim-surround
    rainbow-delimiters-nvim
    yazi-nvim

    # Neat features
    colorful-menu-nvim # Show completion types in color
    cutlass-nvim
    fugitive
    vim-rhubarb # Make `:GBrowse` from fugitive work with Github
    luasnip
    nvim-highlight-colors # Highlight hex codes
    snacks-nvim
    ts-comments-nvim # Lets me have multiple comment strings for `gcc` action
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
    helpview-nvim
    markdown-preview-nvim
    nvim-jdtls
    typst-preview-nvim

    # Dependencies
    nvim-web-devicons
  ];

  # To see all valid values, search this:
  # https://search.nixos.org/packages?channel=unstable&sort=alpha_asc&type=packages&query=vimPlugins.nvim-treesitter-parsers
  # Some languages like Lua aren't included bc nvim already includes them
  treeSitterGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    # The languages I work in everyday
    comment # highlight todos and fixmes
    fish
    gitcommit
    luadoc # --- type annotations
    gleam
    nix

    # Languages I use less often
    bash
    gitignore
    git_rebase
    java
    python
    typst

    # Structured languages
    css
    csv
    diff # .patch files
    html
    json
    toml
    yaml

    # Languages I don't use much, but are common
    cpp
    javascript
    rust
    tsx
    typescript
  ]);

in nixpkgsPlugins ++ [ treeSitterGrammars ]
