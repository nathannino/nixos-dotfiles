{lib, pkgs, python311Packages } :

# Technically, I should be using buildPythonPackage or buildPythonApplication, but I don't want to setup the required file to make a pip package, soo....

pkgs.stdenv.mkDerivation rec {
	pname = "customnotif";
	version = "0.4";
	format = "other";
	src = ./.;

	propagatedBuildInputs = [
		(pkgs.python311.withPackages (pythonPackages: with pythonPackages; [
			python311Packages.dbus-python
			python311Packages.pygobject3
		]))
	];
	buildInputs = [
    		pkgs.gtk3
	];
	nativeBuildInputs = [
    		pkgs.gobject-introspection
		pkgs.wrapGAppsHook3
	];

	# Just look at the manual a few months later and you'll understand this ok. Also gnome wow
	#dontWrapGApps = true;
	#preFixup = ''
	#	makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
	#'';


	dontUnpack = true;
	installPhase = ''
	install -Dm755 ${./customnotif.py} $out/bin/n-customnotif
	'';
}

