{ fetchFromGitHub }:

{
  name = "canola-collection";

  src = fetchFromGitHub {
    owner = "barrettruth";
    repo = "canola-collection";
    rev = "888ee61c54873e0c57df07d35e38284e23bb978c";
    hash = "sha256-AIHHWIzrKv++fI1re3kXcNAiFQ4m1uqLCQO8Bww9fgU=";
  };
}
