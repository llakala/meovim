{ pkgs, exports }:

let
  args = { inherit pkgs; };
in
{
  small ? false,
}:
{
  appName = "nvim";
  neovim = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ./plugins/patches/better-e-binding.patch ];
  });

  luaFiles = [
    ./init.lua
  ];

  plugins = {
    startAttrs = import ./plugins/startPlugins.nix args;
    start = import ./plugins/treesitter.nix args;
    optAttrs = import ./plugins/optPlugins.nix args;
    # Prefixing the name with _ to read my config first when iterating through
    # all `plugin/` files. This prevents plugins from trying to read vim.g
    # values before they've been set (looking at you, canola)
    dev._config = {
      pure = ./nvim;
      impure = "/home/emanresu/Documents/projects/meovim/nvim"; # Absolute path needed
    };
  };
  extraBinPath =
    import ./plugins/binaries.nix args
    ++ [ exports.sadin ]
    ++ (if small then [ ] else import ./plugins/extraBinaries.nix args);
}
