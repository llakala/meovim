{ vimPlugins, fetchFromGitHub, ... }:

vimPlugins.vim-nix.overrideAttrs {
  src = fetchFromGitHub {
    owner = "llakala";
    repo = "vim-nix";
    rev = "bb86088bd29cb80ffa2b738360ccec1e8b0ca0fb";
    hash = "sha256-DPxELPmjMXZxepTnAazzZGecGByUyCwwyJn6f4d9FeQ=";
  };
}
