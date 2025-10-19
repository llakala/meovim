{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  name = "fFtT-highlights-nvim";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "samiulsami";
    repo = "fFtT-highlights.nvim";
    rev = "03dd7d8c9a9c8bc45d35ca47493c9cd97073feb7";
    hash = "sha256-Xf+xuLI17ip88D8R5fC2V/cKFulos1+bzjAXKbBDrbw=";
  };
}
