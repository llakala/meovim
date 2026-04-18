{ vimPlugins, fetchFromGitHub }:

# I reported an issue with duplicate autocmds being created, which the maintainer
# fixed within a day! now just waiting on a nixpkgs bump.
vimPlugins.tiny-inline-diagnostic-nvim.overrideAttrs {
  src = fetchFromGitHub {
    owner = "rachartier";
    repo = "tiny-inline-diagnostic.nvim";
    rev = "610c888153486e10d5d8a509dafa803e4aad916a";
    hash = "sha256-1C0RwkYBe3pQLpfv9/PXC0c3KKFXg8DNSnuOxLWokCs=";
  };
}
