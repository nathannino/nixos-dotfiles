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
      services.xserver.windowManager.qtile = {
        enable = true;
       # configFile = ./../../hosts/nvidiadesktop/qtilecfg.py; # Doesn't work =(. Check home.nix instead
      };


      nixpkgs.overlays = [ # I really should have saved the source oups. Something something reddit comment
        (self: super: {
          qtile-unwrapped = super.qtile-unwrapped.overrideAttrs(new: old: {
            passthru.providedSessions = [ "qtile" "qtile-wayland" ];
                postPatch = let
			qtileWaylandSession = ''
				[Desktop Entry]
				Name=Qtile (Wayland)
				Comment=Qtile on Wayland
				Exec=env XDG_CURRENT_DESKTOP=sway qtile start -b wayland
				Type=Application
				Keywords=wm;tilling
			'';
		in old.postPatch + ''
                  mkdir -p $out/share/wayland-sessions
                  mkdir -p $out/share/xsessions
                  install resources/qtile.desktop -Dt $out/share/xsessions
		  echo "${qtileWaylandSession}" > $out/share/wayland-sessions/qtile-wayland.desktop
		  chmod 777 $out/share/wayland-sessions/qtile-wayland.desktop
		  touch $out/share/wayland-sessions/testing.txt
                  '';
		  # install resources/qtile-wayland.desktop -Dt $out/share/wayland-sessions
          });
        })
      ];

      services.displayManager.sessionPackages = [ pkgs.qtile-unwrapped ];

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
	    swayosd
        ];
	
	systemd.packages = [
		pkgs.swayosd
		pkgs.wayout
	];
	systemd.services.swayosd-libinput-backend.wantedBy = ["default.target"];
    };
}
