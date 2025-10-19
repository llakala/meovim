{ vimPlugins, fetchFromGitHub }:

# Pointing to fork that makes lazydev properly follow `workspace.ignoreDir`
vimPlugins.lazydev-nvim.overrideAttrs {
  src = fetchFromGitHub {
    owner = "alexandre-abrioux";
    repo = "lazydev.nvim";
    rev = "9f9c7af5ee7cccb83c8da1283b4c4e978a15859c";
    hash = "sha256-i8Mzx/Jt6P9hsh7VhjLyX13pZs+mLKA8mh3w3GWKMUM=";
  };
}
