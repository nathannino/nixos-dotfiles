with import <nixpkgs> {};
# Technically, I should be using buildPythonPackage or buildPythonApplication, but I don't want to setup the required file to make a pip package, soo....

pkgs.stdenv.mkDerivation rec {
	name = "customnotif";
	propogatedBuildInputs = [
		(pkgs.python311.withPackages (python-pkgs: with python-pkgs; [
			dbus-python
			pygobject3
		]))
    		pkgs.gobject-introspection
    		pkgs.gtk4
	];
	dontUnpack = true;
	installPhase = "install -Dm755 ${./customnotif.py} $out/bin/customnotif";
}

