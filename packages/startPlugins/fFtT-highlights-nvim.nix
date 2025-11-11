{ fetchFromGitHub }:

# THis isn't an actual plugin derivation, but it's being interpreted as one by
# mnw, which will just reuse `src.outPath` for the plugin definition. Means we
# don't have to include the src in our closure twice. Horrible - I love it.
{
  name = "fFtT-highlights-nvim";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "samiulsami";
    repo = "fFtT-highlights.nvim";
    rev = "b66d65e105cb846d0507a6e80d904f9ee0377b06";
    hash = "sha256-HOfcfsAcnDMsy8epX6R9TPzjFIbvVsLGmfpv2pMsi68=";
  };
}
