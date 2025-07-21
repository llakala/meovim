{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  name = "fFtT-highlights-nvim";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "samiulsami";
    repo = "fFtT-highlights.nvim";
    rev = "b50968a3a30b7eb3de883e16a0c42e756f10f2db";
    hash = "sha256-oal6mYFXyriyf7NLjJz6L09uiDDceUI4drfP9IJNYS4=";
  };
}
