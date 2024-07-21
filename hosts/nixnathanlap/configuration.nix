# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  modulespath = "/../../modules/nixos";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./.${modulespath}/steam.nix
      ./.${modulespath}/intelg.nix
      #./.${modulespath}/python-borked.nix
      ./.${modulespath}/qtile.nix
      ./.${modulespath}/godot.nix
      ./.${modulespath}/default-imports.nix
      ./.${modulespath}/plasma.nix
      ./.${modulespath}/blender.nix
      ./.${modulespath}/jetbrains.nix
      #./.${modulespath}/mpd-system-borked.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixnathanlap"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Modules configuration
  jetbrainide.ultimate = true;
  # mpdmodule.user = "nathan_nino"; # TODO : Change username... yeah probably should find a way to change this based on the user account... =/
  # qtilemodule.configfile = ./qtilecfg.py;
  # pythoncfg.qtile.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nathan_nino = {
    isNormalUser = true;
    description = "Nathan";
    extraGroups = [ "networkmanager" "wheel" "user-with-access-to-virtualbox" "libvirtd" ];
    packages = with pkgs; [
      # This is a single user config, don't use this
    ];
  };

  # See modules/default-hm for further home-manager configuration
  home-manager = {
  extraSpecialArgs = { inherit inputs; };
    users = {
      "nathan_nino" = import ./home.nix;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
