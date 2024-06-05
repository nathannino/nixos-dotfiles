{ config, pkgs, ... }:

{
    imports =
    [
        ./librewolf.nix
        ./mpd-user.nix
        ./xdg-userdirs.nix
	./styling.nix
	./dunst.nix
	./git.nix
    ];
}
