{ fetchFromGitHub }:

{
  name = "canola-collection";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola-collection";
    rev = "bced22e509e8e9253e439e14cd03ab1cfa8c4bfe";
    hash = "sha256-81F4ixghCZ4X6UsNZfCENQnSW/g7R0ACG0rVqUxYsqc=";
  };
}
