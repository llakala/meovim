{ fetchFromGitHub }:

{
  name = "canola-nvim";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola.nvim";
    rev = "88f1344be2b852cd8cad6b866d6eaf7c747abb83";
    hash = "sha256-j9Nrje5dllxEMqzRR9j4Zogu9EoFY/5+UzG7CEEGljU=";
  };
}
