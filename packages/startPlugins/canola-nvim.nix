{ fetchFromGitHub }:

{
  name = "canola-nvim";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola.nvim";
    rev = "6176bccce471937e43375bf9595cd9b458ee838c";
    hash = "sha256-aIzv6olxvhZaLVDL0bEW9vIkbZ22BvUEeZ4SsDCaSeg=";
  };
}
