{ fetchFromGitHub }:

{
  name = "canola-nvim";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola.nvim";
    rev = "2ae54d925e2830601840612a21c1574a4c573266";
    hash = "sha256-g9LkyMnAMHsQo9kkgybFsiP7UGrpcu88wEt6S+oSP3A=";
  };
}
