{ config, pkgs, ... }:

{
  imports =
  [
	./eww.nix
  ];
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/qtile/commons" = {
	source = ./../qtile;
	recursive = true;
    };
    #".config/qtile/keys.py".source = ./../qtile/keys.py;
    #".config/qtile/variables.py".source = ./../qtile/variables.py;
    #".config/qtile/groupsnlayouts.py".source = ./../qtile/groupsnlayouts.py;
    #".config/qtile/hooks.py".source = ./../qtile/hooks.py;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
}
