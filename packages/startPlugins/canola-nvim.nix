{ fetchFromGitHub }:

{
  name = "canola-nvim";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola.nvim";
    rev = "7ee5a20d679f34f48142b1b250b13b9c695b1c03";
    hash = "sha256-Bp9EDqKXrbamPGGmXfXhHP1CUuC7WPmjcEh+VaRq9Bg=";
  };
}
