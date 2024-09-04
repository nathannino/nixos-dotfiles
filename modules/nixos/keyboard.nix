
{lib, config, pkgs, ...}:

{
    config = {
	services.xserver = {
		xkb.layout = "fr,us";
		xkb.options = "grp:win_space_toggle";
	};
    };
}
