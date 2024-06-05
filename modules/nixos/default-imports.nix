
{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./default-packages.nix
      ./default-hm.nix
      ./default-config.nix
      ./default-fonts.nix
      ./mpd-user.nix
      ./creatives.nix # Not certain if default
      ./appimage.nix
    ];
}
