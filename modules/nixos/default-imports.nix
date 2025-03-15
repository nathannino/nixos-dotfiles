
{ config, pkgs, inputs, ... }:

{
	_module.args.pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  imports =
    [
      ./default-packages.nix
      ./default-hm.nix
      ./default-config.nix
      ./default-fonts.nix
      ./default-custom-packages.nix
      ./mpd-user.nix
      ./creatives.nix # Not certain if default
      ./appimage.nix
      ./keyboard.nix
      ./virtual.nix
    ];

    keyboardmodule.layout = "us,ca";
    keyboardmodule.options = "grp:win_space_toggle";
}
