{ nixpkgs, mnw, neovimPlugins, self, ... }:

let
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
    pkgs:
    {
      default = mnw.lib.wrap pkgs
      {
        appName = "nvim";

        neovim = pkgs.neovim-unwrapped;

        initLua =
        ''
          require("myconfig")
        '';

        devExcludedPlugins = lib.singleton ./nvim;

        # Absolute path needed
        devPluginPaths = lib.singleton "/home/emanresu/Documents/projects/meovim/nvim";

        extraBinPath = with pkgs;
        [
          nixd
          jdt-language-server
          fish-lsp
        ];

    # Check https://github.com/NixNeovim/NixNeovimPlugins/blob/main/plugins.md for updates

        plugins = import ./plugins.nix { inherit pkgs neovimPlugins lib; };
      };
    }
  );

  devShells = forAllSystems
  (
    pkgs:
    {
      default = pkgs.mkShell
      {
        packages = lib.singleton self.packages.${pkgs.system}.default.devMode;
      };
    }
  );

}
