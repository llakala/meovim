{ vimPlugins, fetchFromGitHub }:

# Pointing to fork that makes lazydev properly follow `workspace.ignoreDir`
# We actually point to my fork of their fork, that rebases on main to fix a
# deprecation
vimPlugins.lazydev-nvim.overrideAttrs {
  src = fetchFromGitHub {
    owner = "llakala";
    repo = "lazydev.nvim";
    rev = "514e5eda64535742e2f27f725e59db0acbc965d1";
    hash = "sha256-OviKd5hxHL7OA+MQ2REh3Kd7neCjKW50FaJriqtDoV4=";
  };
}
