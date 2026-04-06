{ fetchFromGitHub }:

{
  name = "canola-collection";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola-collection";
    rev = "5d9a22206f7608fb9cbc178b003cdd97daa1b0a3";
    hash = "sha256-bxg1jBl01HN8HnNPtsDc/tg8GC3MAYy7jjqrdV02/Ko=";
  };
}
