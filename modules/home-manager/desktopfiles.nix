{config, pkgs, ...}:
{
	xdg.desktopEntries = {
		steamgamescope = {
			name = "Steam (Gamescope)";
			genericName = "Steam Under Gamescope";
			exec = "${pkgs.gamescope}/bin/gamescope -e -- steam";
			terminal = false;
			categories = [ "Applications" "Network" "Games"];
		};
	};
}
