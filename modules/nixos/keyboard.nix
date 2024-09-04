
{lib, config, pkgs, ...}:

{
    config = {
	services.xserver = {
		xkb.layout = "ca,us";
		xkb.options = "grp:win_space_toggle";
	};
    };
}
