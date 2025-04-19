let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  inherit (lock.nodes.flake-compat.locked) narHash rev url;

  flake-compat = builtins.fetchTarball
  {
    url = "${url}/archive/${rev}.tar.gz";
    sha256 = narHash;
  };

  flake = import flake-compat
  {
    src = ./.;
    copySourceTreeToStore = false;
  };
in
  flake.inputs
