{lib, config, pkgs, ...} :
{
	programs.adb.enable = true;
	environment.systemPackages = with pkgs; [
		pkgs.android-studio
	];
}
