{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "surround-ui-nvim";
  version = "FORK";

  src = fetchFromGitHub {
    owner = "llakala";
    repo = "surround-ui.nvim";
    rev = "b88b2c8fdf9f5add01d14302f2e9833983a6bff6";
    hash = "sha256-3HRx4zQwyiKqJ0phtCvf6ZnoZ2c7XBEMe+y1hWPbpOM=";
  };
}
