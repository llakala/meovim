{ vimPlugins, fetchFromGitHub }:

# Latest commit, since a PR I made to add the fish language got merged
vimPlugins.otter-nvim.overrideAttrs
{
  version = "2025-02-26";
  src = fetchFromGitHub
  {
    owner = "jmbuhr";
    repo = "otter.nvim";
    rev = "213d1f7a47be788f430099a110456a06167ab0f4";
    hash = "sha256-noACuQSlk/ymBPl6jBLxG7a9mvdGypBm6+3s27L7ek0=";
  };
}
