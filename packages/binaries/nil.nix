{ nil, fetchFromGitHub, rustPlatform, ... }:

# Version in nixpkgs is out of date and doesn't have a fix to remove comment
# completion
nil.overrideAttrs (final: prev: {
  version = "0-unstable-2025-12-09";
  src = fetchFromGitHub {
    owner = "oxalica";
    repo = "nil";
    rev = "504599f7e555a249d6754698473124018b80d121";
    hash = "sha256-18j8X2Nbe0Wg1+7YrWRlYzmjZ5Wq0NCVwJHJlBIw/dc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (final) src;
    hash = "sha256-LS2IW4gZ1k6Xl5weMNwxvVA2z56r4rPkjqrkROZTmBw=";
  };
})
