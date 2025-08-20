let
  inputs = import ./other/inputs.nix;
  inherit (inputs) nixpkgs mnw neovimPlugins;
  inherit (nixpkgs) lib;
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};

  mkPackageSet = { extras ? {}, filepaths }: let
    callPackage = lib.callPackageWith (pkgs // extras // { localPackages = packages; });
    packages = builtins.mapAttrs
      (_: path: callPackage path {})
      filepaths;
  in packages;

  startPlugins = import ./other/startPlugins.nix { inherit pkgs neovimPlugins; };
  customStartPlugins = mkPackageSet {
    filepaths = {
      vim-nix = ./other/startPlugins/vim-nix.nix;
      fFtT-highlights-nvim = ./other/startPlugins/fFtT-highlights-nvim.nix;
      lazydev-nvim = ./other/startPlugins/lazydev-nvim.nix;
    };
  };

  optPlugins = import ./other/optPlugins.nix { inherit pkgs neovimPlugins; };
  customOptPlugins = mkPackageSet {
    filepaths = {};
  };

  binaries = import ./other/binaries.nix { inherit pkgs; };
  customBinaries = mkPackageSet {
    filepaths = {};
  };
in mnw.lib.wrap pkgs {
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
    vim.lsp.enable({ "fish_lsp", "gleam", "lua_ls", "nixd", "basedpyright", "ts_ls", "marksman" })
  '';

  plugins.start =
    startPlugins
    ++ builtins.attrValues customStartPlugins;

  plugins.opt =
    optPlugins
    ++ builtins.attrValues customOptPlugins;

  extraBinPath =
    binaries
    ++ builtins.attrValues customBinaries;

  plugins.dev.config = {
    pure = ./nvim;
    impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
  };
}

