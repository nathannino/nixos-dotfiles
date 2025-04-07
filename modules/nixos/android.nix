{lib, config, pkgs, ...} :

let
	myAndroid = pkgs.android-studio.overrideAttrs (finalAttrs: previousAttrs: {
		buildInputs = [
			pkgs.flutter
			pkgs.dart
		];
	});
in
{
	programs.adb.enable = true;
	environment.systemPackages = [
		myAndroid
		pkgs.dart
	];
}
