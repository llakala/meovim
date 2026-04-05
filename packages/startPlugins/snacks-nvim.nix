{ vimPlugins, fetchFromGitHub }:
vimPlugins.snacks-nvim.overrideAttrs {
  src = fetchFromGitHub {
    owner = "llakala";
    repo = "snacks.nvim";
    rev = "47ca25afc8a3e0c86ce7f9fb8099a378f3fed12b";
    hash = "sha256-7X2KeYWdrXDp9xL5ujXXqHlsMJUpOVsXqzrepYrn9Mk=";
  };
}
