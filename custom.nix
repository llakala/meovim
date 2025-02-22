{ pkgs, lib }:

let
  inherit (pkgs.vimUtils) buildVimPlugin;
  inherit (pkgs) fetchFromGitHub;

  # Put all the packages in an attrset, then use attrVals to export all of them
  # Better UX than lists because of parentheses problems
  packages =
  {
    textobj-line = buildVimPlugin
    {
      name = "vim-textobj-line";

      src = fetchFromGitHub
      {
        owner = "kana";
        repo = "vim-textobj-line";
        rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
        hash = "sha256-k6kjmwNqmklVaCigMzBL7xpuMAezqT2G3ZcPtCp791Y=";
      };
    };

    # Fork with some bug fixes
    wilder-nvim = buildVimPlugin
    {
      pname = "wilder.nvim";
      version = "unstable";

      src = fetchFromGitHub
      {
        owner = "ogaken-1";
        repo = "wilder.nvim";
        rev = "62c65e0ea1120b6b564d343a4b638c083e264d2d";
        sha256 = "sha256-LMuP0FNgTaPnQOO0GWdmR86pVgOt6ImdBN6WFiiMRbo=";
      };

      meta.homepage = "https://github.com/gelguy/wilder.nvim/";
    };

  };
in
  builtins.attrValues packages
