{ config, pkgs, ...} :

let
	arduino-appimage = pkgs.fetchurl {
		url = "https://github.com/arduino/arduino-ide/releases/download/2.3.4/arduino-ide_2.3.4_Linux_64bit.AppImage";
		sha256 = "ksrns5zaaqn8rv877l0lzl7mhjvkdxzq8lnz4s6lhn4jdybf99z";
	};
in
{
	home.file.".appimages/arduino-ide.AppImage" = {
		executable = true;
		source = arduino-appimage;
	};

	xdg.desktopEntries = {
		arduino-ide = {
			name = "Arduino IDE Appimage";
			genericName = "Arduino IDE";
			exec = "/home/nathan_nino/.appimages/arduino-ide.AppImage";
			terminal = false;
			categories = [ "Application" ];
		};
	};
}
