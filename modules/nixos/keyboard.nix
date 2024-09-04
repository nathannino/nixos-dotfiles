
{lib, config, pkgs, ...}:

{
    config = {
	services.xserver = {
		layout = "fr,us";
		xkbOptions = "grp:win_space_toggle";
	};
    };
}
