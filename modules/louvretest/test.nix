{lib, config, pkgs, ...}:

{
	environment.systemPackages = [
		pkgs.wprs
	];
	environment.etc."wayland-sessions/impatientcomp.desktop" = {
		text = ''
				[Desktop Entry]
				Name=Louvre Test Entry
				Exec=/home/nathan_nino/test/louvre
				Type=Application
			'';
	};
}
