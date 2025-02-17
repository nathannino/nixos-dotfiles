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
      ./.${modulespath}/nvidia.nix
      ./.${modulespath}/steam.nix
      #./.${modulespath}/python-borked.nix
      ./.${modulespath}/plasma6.nix
      ./.${modulespath}/qtile.nix
      ./.${modulespath}/godot.nix
      ./.${modulespath}/default-imports.nix
      ./.${modulespath}/blender.nix
      ./.${modulespath}/jetbrains.nix
      #./.${modulespath}/mpd-system-borked.nix
      inputs.home-manager.nixosModules.default
      #inputs.nixvim.nixosModules.nixvim
      ./../../modules/nixvim/default.nix
      # ./../../modules/nixvim/nonixvim.nix # No nix vim support, enable regular neovim
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nvidiadesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Modules configuration
  nvidiamodule.enable = true;
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
  system.stateVersion = "24.11"; # Did you read the comment?

}
