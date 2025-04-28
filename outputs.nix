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
  # Custom derivations for plugins loaded at startup
  customNonLazyPlugins = forAllSystems
  (
    pkgs: llakaLib.collectDirectoryPackages
    {
      inherit pkgs;
      directory = ./plugins/nonLazy;
    }
  );

  # Custom derivations for plugins loaded lazily. Keeping this commented out for
  # now, since the directory is empty, and would fail when trying to access it.
  customLazyPlugins = forAllSystems
  (
    pkgs:
    {}
    # llakaLib.collectDirectoryPackages
    # {
    #   inherit pkgs;
    #   directory = ./plugins/lazy;
    # }
  );

  # Custom binaries to add to $PATH
  customPackages = forAllSystems
  (
    pkgs: llakaLib.collectDirectoryPackages
    {
      inherit pkgs;
      directory = ./packages;
    }
  );

  packages = forAllSystems
  (
    pkgs: let
      # Lists of derivations that we grab from external sources (nixpkgs and
      # neovimPlugins)
      nonLazyPlugins = import ./plugins/nonLazy.nix { inherit pkgs neovimPlugins; };
      lazyPlugins = import ./plugins/lazy.nix { inherit pkgs neovimPlugins; };
      packages = import ./packages.nix { inherit pkgs; };

      # Custom definitions are stored in their own flake inputs, so they can be
      # checked in the repl and other places to ensure functionality. The current
      # data is stored as an attrset, so we turn it into a list.
      customNonLazyPlugins = builtins.attrValues self.customNonLazyPlugins.${pkgs.system};
      customLazyPlugins = builtins.attrValues self.customLazyPlugins.${pkgs.system};
      customPackages = builtins.attrValues self.customPackages.${pkgs.system};

      mnw = inputs.mnw.lib.wrap pkgs
      {
        appName = "nvim";
        neovim = pkgs.neovim-unwrapped;

        initLua =
        /* lua */
        ''
          require("config")
          require("plugins")
          require("lsp")
          require("lz.n").load("lazy")
        '';

        plugins.start =
          nonLazyPlugins
          ++ customNonLazyPlugins;

        plugins.opt =
          lazyPlugins
          ++ customLazyPlugins;

        extraBinPath =
          packages ++
          customPackages;

        plugins.dev.config =
        {
          pure = ./nvim;
          impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
        };

      };

    in { default = mnw; }
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
