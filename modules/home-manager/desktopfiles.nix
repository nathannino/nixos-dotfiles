{config, pkgs, ...}:
{
	xdg.desktopEntries = {
		steamgamescope = {
			type = "Application";
			name = "Steam (Gamescope)";
			genericName = "Steam Under Gamescope";
			exec = "${pkgs.gamescope}/bin/gamescope -e -- steam";
			terminal = false;
			categories = ["Network" "Game"];
		};
	};
}
