{lib, config, pkgs, ...}:

let
  cfg = config.qtilemodule;
in
{
    #options.qtilemodule = {
    #  configfile = lib.mkOption {
    #    type = lib.types.nullOr lib.types.path;
    #    description = "The location of the host-specific config file.";
    #    default = null; # TODO : Add a default config, because pretty sure having it be null makes it not build
    #  };
    #};
    config = {
      nixpkgs.overlays = [ # I really should have saved the source oups. Something something reddit comment
        (self: super: {
          qtile-unwrapped = super.qtile-unwrapped.overrideAttrs(new: old: {
            passthru.providedSessions = [ "qtile" "qtile-wayland" ];
                postPatch = old.postPatch + ''
                  mkdir -p $out/share/wayland-sessions
                  mkdir -p $out/share/xsessions
                  install resources/qtile.desktop -Dt $out/share/xsessions
                  install resources/qtile-wayland.desktop -Dt $out/share/wayland-sessions
                  '';
          });
        })
      ];

      services.displayManager.sessionPackages = [ pkgs.qtile-unwrapped ];

      services.xserver.windowManager.qtile = {
        enable = true;
       # configFile = ./../../hosts/nvidiadesktop/qtilecfg.py; # Doesn't work =(. Check home.nix instead
      };

      # services.picom.enable = true;
	
	nixpkgs.config.packageOverrides = pkgs: {
		customnotif = pkgs.callPackage ./../../homemade/notifications/customnotif.nix { };
	};

        environment.systemPackages = with pkgs; [
            eww #TODO : Maybe this could be seperated... not sure
            picom #TODO : Only install with no wayland? Not how our thing works right now tho
            # rofi # We using eww instead omg # ok quick update GOD NO. We are not using eww instead this is a horrible idea whyyyyyyyyy
            # wofi
            rofi-wayland # turns out this also supports xorg, I am the stupid
	    customnotif
	    networkmanagerapplet
        ];
    };
}
