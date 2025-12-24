{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    neovim = {
      url = "github:neovim/neovim/d7b882697b5dc307a6396ec6163e41dfc74b076d"; # Pinned to commit I've already built
      flake = false;
    };
  };

  outputs = { self, nixpkgs, mnw, neovim }:
  let
    lib = nixpkgs.lib;
    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = function: lib.genAttrs
      supportedSystems
      (system: function nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: {
      default = import ./default.nix { inherit pkgs mnw neovim; small = false; };
      small = import ./default.nix { inherit pkgs mnw neovim; small = true; };
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = lib.singleton self.packages.${pkgs.stdenv.hostPlatform.system}.default.devMode;
      };
    });
  };
}
