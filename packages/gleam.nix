{ gleam, fetchFromGitHub, rustPlatform }:

gleam.overrideAttrs (finalAttrs: prevAttrs: {
  version = "1.10-unstable";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = prevAttrs.pname;
    rev = "53d34568fd6332287b56a5b48eefb984b9aa2c5e"; # Latest commit as of 3/30/25
    hash = "sha256-rGP5cs46jHX9gtl7e5ylBivqXB/JvycyKSZZb+cau70=";
  };

  cargoHash = "sha256-1jZmqLXGAWnAWlFhOV40Lfqwapa/pX/jLFXeKFcxxkQ=";

  # overrideAttrs isn't built for buildRustPackage, since it works on mkDerivation.
  # To get around this, we make the above cargoHash also affect the cargoDeps,
  # so it actually does something.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = finalAttrs.cargoHash;
  };
})
