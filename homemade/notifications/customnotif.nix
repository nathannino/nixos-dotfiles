{lib, pkgs, python311Packages } :

# Technically, I should be using buildPythonPackage or buildPythonApplication, but I don't want to setup the required file to make a pip package, soo....

python311Packages.buildPythonApplication rec {
	pname = "customnotif";
	version = "0.1";
	format = "other";
	src = ./.;

	propagatedBuildInputs = [
		python311Packages.dbus-python
		python311Packages.pygobject3
    		pkgs.gobject-introspection
    		pkgs.gtk4
	];
	dontUnpack = true;
	installPhase = ''
	install -Dm755 ${./customnotif.py} $out/bin/customnotif
	'';
}

