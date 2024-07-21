# kde plasma 6 specific stuff

{lib, config, pkgs, ...}:

{
    config = {

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # services.displayManager.sddm.wayland.enable = true; # Disabled until I can fix the resolution on second screen
  services.desktopManager.plasma6.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ # When starting the config split, check if each package could be included in homemanager
    kdePackages.kscreen
    kdePackages.sddm-kcm
  ];
    };
}
