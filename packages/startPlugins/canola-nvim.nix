{ fetchFromGitHub }:

{
  name = "canola-nvim";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola.nvim";
    rev = "3838f1380e9aeea0597a80beb6ab28da73e38525";
    hash = "sha256-iQh/QeKeELxNsWsWPO/GsNiYdXhZM7vv7Q0uQjO4sJE=";
  };
}
