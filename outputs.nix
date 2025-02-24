{ self, ... } @ inputs:

let
  inherit (inputs) nixpkgs neovimPlugins;

  lib = nixpkgs.lib;

  # It's a personal repo, not supporting other systems right now
  supportedSystems = lib.singleton "x86_64-linux";

  forAllSystems = function: lib.genAttrs
    supportedSystems
    (system: function nixpkgs.legacyPackages.${system});

in
{
  packages = forAllSystems
  (
    pkgs: let llakaLib = inputs.llakaLib.fullLib.${pkgs.system};
    in
    {
      default = inputs.mnw.lib.wrap pkgs
      {
        appName = "nvim";

        neovim = pkgs.neovim-unwrapped;

        initLua =
        ''
          require("config")
          require("plugins")
        '';

        devExcludedPlugins = lib.singleton ./nvim;

        # Absolute path needed
        devPluginPaths = lib.singleton "/home/emanresu/Documents/projects/meovim/nvim";

        extraBinPath = import ./packages.nix { inherit pkgs lib llakaLib; };

    # Check https://github.com/NixNeovim/NixNeovimPlugins/blob/main/plugins.md for updates

        plugins = import ./plugins.nix { inherit pkgs neovimPlugins lib llakaLib; };
      };
    }
  );

  devShells = forAllSystems
  (
    pkgs:
    {
      default = pkgs.mkShellNoCC
      {
        packages = lib.singleton self.packages.${pkgs.system}.default.devMode;
      };
    }
  );

}
