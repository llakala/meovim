{ vimPlugins, fetchFromGitHub }:

vimPlugins.rainbow-delimiters-nvim.overrideAttrs
{
  # Grab from my fork
  src = fetchFromGitHub
  {
    owner = "llakala";
    repo = "rainbow-delimiters.nvim";
    rev = "d3c50f95fe100e84371fae6d2bbebf36b9e5dc53";
    hash = "sha256-MaDEWkxyl5i9lIUO8V5ggwRQxRl3FPRft2Pu1I/tzmc=";
  };
}
