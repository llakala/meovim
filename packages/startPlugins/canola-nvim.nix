{ fetchFromGitHub }:

{
  name = "canola-nvim";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola.nvim";
    rev = "4d32c1f28359ea4b86baa08cfcc3d81e202f4c56";
    hash = "sha256-qmClgnZfMnXUcobZsPLeRTE5OUhyl6NWsCOo85h3QlQ=";
  };
}
