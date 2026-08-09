{ gps, writeShellApplication }:

writeShellApplication {
  name = "sadin"; # Split a Diff in Neovim

  runtimeInputs = [
    gps
  ];
  text = builtins.readFile ./sadin.sh;
}
