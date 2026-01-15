{ vimPlugins, fetchFromGitHub }:

vimPlugins.oil-nvim.overrideAttrs {
  src = fetchFromGitHub {
    owner = "llakala";
    repo = "oil.nvim";
    rev = "9bf121138f0d1e70d683acececd6dcea09193f94";
    hash = "sha256-gKV4WUfX1Gq2wPV28ujKO7Ba9WjuCcIbuEU0aCkeJng=";
  };
}
