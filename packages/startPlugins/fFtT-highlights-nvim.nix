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
    rev = "03dd7d8c9a9c8bc45d35ca47493c9cd97073feb7";
    hash = "sha256-Xf+xuLI17ip88D8R5fC2V/cKFulos1+bzjAXKbBDrbw=";
  };
}
