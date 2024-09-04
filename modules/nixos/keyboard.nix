
{lib, config, pkgs, ...}:

{
    config = {
	services.xserver = {
		xkb.layout = "fr,us";
		xkb.xkbOptions = "grp:win_space_toggle";
	};
    };
}
