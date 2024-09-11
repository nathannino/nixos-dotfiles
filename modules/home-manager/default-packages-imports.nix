{ config, pkgs, ... }:

{
    imports =
    [
        ./librewolf.nix
        ./xdg-userdirs.nix
        ./styling.nix
        ./dunst.nix
        ./git.nix
        ./sessionvariables.nix
	./alacritty.nix
	#./kdeconnect.nix
    ];
}
