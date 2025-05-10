{lib, config, pkgs, ...}:

{
	nixpkgs.config.packageOverrides = pkgs: {
		louvresession = pkgs.callPackage ./session.nix { };
	};
	environment.systemPackages = [
		pkgs.wprs
		pkgs.louvresession
	];
}
