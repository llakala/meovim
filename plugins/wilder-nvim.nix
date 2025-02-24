{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin
{
  pname = "wilder.nvim";
  version = "unstable";

  src = fetchFromGitHub
  {
    owner = "ogaken-1";
    repo = "wilder.nvim";
    rev = "62c65e0ea1120b6b564d343a4b638c083e264d2d";
    sha256 = "sha256-LMuP0FNgTaPnQOO0GWdmR86pVgOt6ImdBN6WFiiMRbo=";
  };
}
