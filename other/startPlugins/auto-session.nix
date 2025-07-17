{ vimPlugins, fetchFromGitHub }:

vimPlugins.auto-session.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "cameronr";
    repo = "auto-session";
    rev = "79981cae13b9a253095fb01c9bb6e4dbf867d40b";
    hash = "sha256-OIPyn4YXDqZfaiNZufDXcG68cLvrgl5vfVSB719wle4=";
  };
})
