{ vimPlugins, fetchFromGitHub }:

# My fork adding the Gleam language
vimPlugins.otter-nvim.overrideAttrs
{
  version = "2025-03-17";
  src = fetchFromGitHub
  {
    owner = "llakala";
    repo = "otter.nvim";
    rev = "75eab83621a7bf29e6d5e1b9d07cac10ed59f34b";
    hash = "sha256-BuhtO4VN3TbHoxtLY+kmcCFucalsP3seK1TXCjCOCzs=";
  };
}
