{lib, config, pkgs, ...}:

{
  xdg.portal = {
	enable = true;
	#extraPortals = [ # Let's see if we can make it use the config file instead
	#		#pkgs.xdg-desktop-portal-gtk
	##		pkgs.kdePackages.xdg-desktop-portal-kde
	#		pkgs.xdg-desktop-portal-wlr
	#];
	wlr.enable = true;
	config = {
		sway = {
			default = [
				"kde"
			];
			"org.freedesktop.impl.portal.Screenshot" = [
				"wlr"
			];
			"org.freedesktop.impl.portal.ScreenCast" = [
				"wlr"
			];
		};
	};
  };

}
