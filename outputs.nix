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
  # Plugins packaged myself that get loaded at startup. Keeping this commented
  # out for now, since the directory is currently empty, and
  # `collectDirectoryPackages` freaks out when trying to access an empty
  # directory.
  customNonLazyPlugins = forAllSystems
  (
    pkgs:
    {}

    # llakaLib.collectDirectoryPackages
    # {
    #   inherit pkgs;
    #   directory = ./plugins/nonLazy;
    # }
  );

  # Plugins packaged myself that get loaded lazily.
  customLazyPlugins = forAllSystems
  (
    pkgs: llakaLib.collectDirectoryPackages
    {
      inherit pkgs;
      directory = ./plugins/lazy;
    }
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
    in
    {
      default = inputs.mnw.lib.wrap pkgs
      {
        appName = "nvim";
        neovim = pkgs.neovim-unwrapped;

        initLua =
        /* lua */
        ''
          -- Uncomment when you want to profile nvim startup. Be sure to have
          -- the snacks.nvim repo cloned for this to work!

          -- vim.opt.rtp:append("/home/emanresu/Documents/repos/snacks.nvim/")
          -- require("snacks.profiler").startup()

          require("config")
          require("lz.n").load("lazy")

          -- Add to this whenever you add a new server to the `lsp` folder!
          -- Ridiculous that nvim can't load them for you as far as I can tell
          vim.lsp.enable({ "fish_lsp", "gleam", "lua_ls", "nixd", "pylsp", "ts_ls" })
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
