{
  inputs =
  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";

    llakaLib =
    {
      url = "github:llakala/llakaLib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not actually using this, but we need to pin the version for neovimPlugins
    # pass in your own flake-utils to prevent duplication
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat =
    {
      url = "git+https://git.lix.systems/lix-project/flake-compat.git";
      # Optional, this repo's flake.nix just imports their default.nix, so this skips a step
      flake = false;
    };

    neovimPlugins =
    {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs:
  let
    supportedSystems = [ "x86_64-linux" ];
    forEachSystem = inputs.nixpkgs.lib.genAttrs supportedSystems;
  in
  {
    packages = forEachSystem (system: {
      default = import ./default.nix { inherit inputs system; };
    });

    devShells = forEachSystem (system: {
      default = import ./shell.nix { inherit inputs system; };
    });
  };
}
