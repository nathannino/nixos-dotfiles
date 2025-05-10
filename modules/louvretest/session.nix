{ stdenv } :

stdenv.mkDerivation {
	version = "0.1";
	name = "LouvreTemplate";
	src = ./files;
	installPhase = ''
		mkdir -p $out/share/wayland-sessions/
		cp * $out/share/wayland-sessions/
	'';
}
