{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";

    # Not actually using this, but we need to pin the version for neovimPlugins
    # pass in your own flake-utils to prevent duplication
    flake-utils.url = "github:numtide/flake-utils";

    neovimPlugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-compat = {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
      flake = false;
    };
  };

  outputs = _: { };
}
