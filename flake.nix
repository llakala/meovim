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
  };

  outputs = { self, nixpkgs, neovimPlugins, ... } @ inputs:
  let
    lib = nixpkgs.lib;

    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = function: lib.genAttrs
      supportedSystems
      (system: function nixpkgs.legacyPackages.${system});

    # Simple callPackage wrapper for easy self-reference
    mkPackageSet = { pkgs, extras ? {}, filepaths }: let
      callPackage = lib.callPackageWith (pkgs // extras // { localPackages = packages; });
      packages = builtins.mapAttrs
        (_: path: callPackage path {})
        filepaths;
    in packages;

  in {
    # When I need something and it isn't packaged already somewhere, I package it
    # myself. I have these accessible as flake inputs, so I can test them in the
    # REPL.
    #
    # Note that these are disabled when I don't have anything custom right now!
    neovimStartPlugins = forAllSystems (pkgs: mkPackageSet {
      inherit pkgs;
      filepaths = {
        vim-nix = ./other/startPlugins/vim-nix.nix;
        fFtT-highlights-nvim = ./other/startPlugins/fFtT-highlights-nvim.nix;
        lazydev-nvim = ./other/startPlugins/lazydev-nvim.nix;
      };
    });

    neovimOptPlugins = forAllSystems (pkgs: mkPackageSet {
      inherit pkgs;
      filepaths = {};
    });

    neovimBinaries = forAllSystems (pkgs: mkPackageSet {
      inherit pkgs;
      filepaths = {};
    });


    packages = forAllSystems (pkgs: let
      # Binaries and plugins that I grab from elsewhere. Stored in their own
      # files so I'm not editing monolithic files to add stuff
      startPlugins = import ./startPlugins.nix { inherit pkgs neovimPlugins; };
      optPlugins = import ./optPlugins.nix { inherit pkgs neovimPlugins; };
      binaries = import ./binaries.nix { inherit pkgs; };

      # Custom derivations that I wrote myself. Need to be turned into a list,
      # since flake inputs are expected to be attrsets.
      customStartPlugins = builtins.attrValues self.neovimStartPlugins.${pkgs.system};
      customOptPlugins = builtins.attrValues self.neovimOptPlugins.${pkgs.system};
      customPackages = builtins.attrValues self.neovimBinaries.${pkgs.system};
    in {
      default = inputs.mnw.lib.wrap pkgs {
        appName = "nvim";
        neovim = pkgs.neovim-unwrapped;

        initLua = /* lua */ ''
          -- Uncomment when you want to profile nvim startup. Be sure to have
          -- the snacks.nvim repo cloned for this to work!

          -- vim.opt.rtp:append("/home/emanresu/Documents/repos/snacks.nvim/")
          -- require("snacks.profiler").startup()

          require("config")
          require("lz.n").load("lazy")

          -- Add to this whenever you add a new server to the `lsp` folder!
          -- Ridiculous that nvim can't load them for you as far as I can tell
          vim.lsp.enable({ "fish_lsp", "gleam", "lua_ls", "nil_ls",
          "basedpyright", "ts_ls", "marksman", "tinymist", "clangd" })
        '';

        plugins.start =
          startPlugins
          ++ customStartPlugins;

        plugins.opt =
          optPlugins
          ++ customOptPlugins;

        extraBinPath =
          binaries ++
          customPackages;

        plugins.dev.config = {
          pure = ./nvim;
          impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
        };
      };
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = lib.singleton self.packages.${pkgs.system}.default.devMode;
      };
    });

  };
}
