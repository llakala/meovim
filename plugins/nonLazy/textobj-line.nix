{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin
{
  name = "vim-textobj-line";

  src = fetchFromGitHub
  {
    owner = "kana";
    repo = "vim-textobj-line";
    rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
    hash = "sha256-k6kjmwNqmklVaCigMzBL7xpuMAezqT2G3ZcPtCp791Y=";
  };
}
