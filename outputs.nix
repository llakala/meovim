{ self, ... } @ inputs:

let
  inherit (inputs) nixpkgs neovimPlugins;
  lib = nixpkgs.lib;

  supportedSystems = [ "x86_64-linux" ];
  forAllSystems = function: lib.genAttrs
    supportedSystems
    (system: function nixpkgs.legacyPackages.${system});

  llakaLib = inputs.llakaLib.pureLib; # Don't need any impure functions
in
{
  /**
    All the custom packages/plugins that meovim uses.
    We export these as their own flake outputs, so we can test them
    in devshells + repl, and also add them to the inputs of the meovim
    package without any re-evalution by just accessing `self`.
    These don't include the non-custom stuff from other sources, since
    they're already accessible for testing elsewhere.
  */
  neovimPlugins = forAllSystems
  (
    pkgs: llakaLib.collectDirectoryPackages
    {
      inherit pkgs;
      directory = ./plugins;
    }
  );

  neovimPackages = forAllSystems
  (
    pkgs: llakaLib.collectDirectoryPackages
    {
      inherit pkgs;
      directory = ./packages;
    }
  );

  packages = forAllSystems
  (
    pkgs:
    {
      default = inputs.mnw.lib.wrap pkgs
      {
        appName = "nvim";

        neovim = pkgs.neovim-unwrapped;

        initLua =
        /* lua */
        ''
          require("config")
          require("plugins")
          require("lsp")
        '';

        devExcludedPlugins = lib.singleton ./nvim;

        # Absolute path needed
        devPluginPaths = lib.singleton "/home/emanresu/Documents/projects/meovim/nvim";

        # customPlugins and customPackages are stored in their own flake
        # inputs, so they can be used in multiple places and only get
        # evaluated once. We grab them and turn them into a list via attrValues, combining with the list of non-custom plugins/packages
        plugins =
          import ./plugins.nix { inherit pkgs neovimPlugins; } ++
          builtins.attrValues self.neovimPlugins.${pkgs.system};
        extraBinPath =
          import ./packages.nix { inherit pkgs; } ++
          builtins.attrValues self.neovimPackages.${pkgs.system};
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
