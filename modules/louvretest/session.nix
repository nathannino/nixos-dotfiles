{ stdenv } :

stdenv.mkDerivation {
	version = "0.1";
	name = "LouvreTemplate";
	src = ./.;
	installPhase = ''
		mkdir -p $out/share/wayland-sessions/
		cp ${./impatientcomp.desktop} $out/share/wayland-sessions/
	'';
}
