{ pkgs, mnw }:

let
  inherit (pkgs) lib;

  mkPackageSet = filepaths: let
    callPackage = lib.callPackageWith (pkgs // { localPackages = packages; });
    packages = builtins.mapAttrs
      (_: path: callPackage path {})
      filepaths;
  in packages;

  startPlugins = import ./startPlugins.nix { inherit pkgs; };
  optPlugins = import ./optPlugins.nix { inherit pkgs; };
  binaries = import ./binaries.nix { inherit pkgs; };

  customStartPlugins = mkPackageSet {
    vim-nix = ./other/startPlugins/vim-nix.nix;
    fFtT-highlights-nvim = ./other/startPlugins/fFtT-highlights-nvim.nix;
    lazydev-nvim = ./other/startPlugins/lazydev-nvim.nix;
  };
  customOptPlugins = {};
  customBinaries = {};

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
    vim.lsp.enable({ "fish_lsp", "gleam", "lua_ls", "nixd",
    "basedpyright", "ts_ls", "marksman", "tinymist", "clangd" })
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
