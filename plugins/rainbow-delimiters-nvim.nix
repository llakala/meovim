{ vimPlugins, fetchFromGitHub }:

vimPlugins.rainbow-delimiters-nvim.overrideAttrs
{
  # Grab from my fork
  src = fetchFromGitHub
  {
    owner = "llakala";
    repo = "rainbow-delimiters.nvim";
    rev = "2fef0566f811b1a5d79f3484e61194576b870db3";
    hash = "sha256-hnIE4jxi+scFhV6C8baKQ4bsRTHU0//RJab7pDKVx/I=";
  };
}
