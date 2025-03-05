{ pkgs, fetchFromGitHub, fetchYarnDeps }:

# Content from my PR to update the package, while I wait for it to be merged.
# See: https://github.com/NixOS/nixpkgs/pull/385076
pkgs.fish-lsp.overrideAttrs
(
  final: old:
  {
    version = "1.0.8-4";

    src = fetchFromGitHub
    {
      owner = "ndonfris";
      repo = "fish-lsp";
      tag = "v${final.version}";
      hash = "sha256-rtogxbcnmOEFT1v7aK+pzt9Z4B2O4rFwH3pTNVLTxiA=";
    };

    yarnOfflineCache = fetchYarnDeps
    {
      yarnLock = final.src + "/yarn.lock";
      hash = "sha256-83QhVDG/zyMbHJbV48m84eimXejLKdeVrdk1uZjI8bk=";
    };

  postPatch =
  ''
    patchShebangs bin/fish-lsp
  '';
  }
)
