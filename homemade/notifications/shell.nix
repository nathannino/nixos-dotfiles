# shell.nix
let
  # We pin to a specific nixpkgs commit for reproducibility.
  # Last updated: 2024-06-10. Check for new commits at https://status.nixos.org.
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/3bcedce9f4de37570242faf16e1e143583407eab.tar.gz") {};
in pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: [
      # select Python packages here
      python-pkgs.dbus-python
      python-pkgs.pygobject3
      python-pkgs.jedi-language-server
      python-pkgs.pypng
    ]))
    pkgs.gobject-introspection
    pkgs.gtk4
  ];
}
