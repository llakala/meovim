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

    neovimPlugins =
    {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, neovimPlugins, ... } @ inputs:
  let
    lib = nixpkgs.lib;

    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = function: lib.genAttrs
      supportedSystems
      (system: function nixpkgs.legacyPackages.${system});

    llakaLib = inputs.llakaLib.pureLib; # Don't need any impure functions
  in
  {
    # When I need something and it isn't packaged already somewhere, I package it
    # myself. I have these accessible as flake inputs, so I can test them in the
    # REPL. I use my own custom wrapper around
    # `lib.packagesFromDirectoryRecursive` to automatically get any package stored
    # in these folders.


    # Plugins to be loaded at start. We comment this out for now, because
    # `packagesFromDirectoryRecursive` will error if the folder is empty.
    neovimNonLazyPlugins = forAllSystems
    (
      pkgs:
      {}

      # llakaLib.collectDirectoryPackages
      # {
      #   inherit pkgs;
      #   directory = ./other/nonLazyPlugins;
      # }
    );

    # Plugins packaged myself that get loaded lazily.
    neovimLazyPlugins = forAllSystems
    (
      pkgs: llakaLib.collectDirectoryPackages
      {
        inherit pkgs;
        directory = ./other/lazyPlugins;
      }
    );

    # Custom binaries to add to $PATH
    neovimPackages = forAllSystems
    (
      pkgs: llakaLib.collectDirectoryPackages
      {
        inherit pkgs;
        directory = ./other/packages;
      }
    );

    packages = forAllSystems
    (
      pkgs: let
        # Packages and plugins that I grab from elsewhere. Stored in their own
        # files so I'm not editing monolithic files to add stuff
        nonLazyPlugins = import ./nonLazyPlugins.nix { inherit pkgs neovimPlugins; };
        lazyPlugins = import ./lazyPlugins.nix { inherit pkgs neovimPlugins; };
        packages = import ./packages.nix { inherit pkgs; };

        # Custom derivations that I wrote myself. Need to be turned into a list,
        # since flake inputs are expected to be attrsets.
        customNonLazyPlugins = builtins.attrValues self.neovimNonLazyPlugins.${pkgs.system};
        customLazyPlugins = builtins.attrValues self.neovimLazyPlugins.${pkgs.system};
        customPackages = builtins.attrValues self.neovimPackages.${pkgs.system};
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

  };
}
