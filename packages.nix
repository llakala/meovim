{ pkgs, lib, llakaLib }:
let
  packages = with pkgs;
  [
    nixd
    jdt-language-server
    yazi
    lua-language-server
    gleam
  ];

  customPackagesAttrs = llakaLib.collectDirectoryPackages
  {
    inherit pkgs;
    directory = ./packages;
  };

  # collectDirectoryPackages gives us an attrset as output. we grab the values of the attrs
  # when they're derivations, going recursively through `lib.collect`
  customPackages = lib.collect lib.isDerivation customPackagesAttrs;

in packages ++ customPackages
