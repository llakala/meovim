{ pkgs }:

{
  inherit (pkgs.vimPlugins)
    helpview-nvim
    typst-preview-nvim
    nvim-jdtls
    markdown-preview-nvim
    ;
}
