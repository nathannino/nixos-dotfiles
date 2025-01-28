# TODO : Switch to godot mono support

{lib, config, pkgs, ...}:

{
    config = {

        environment.systemPackages = with pkgs; [
            slack
	    teams-for-linux # Insert swear word here
        ];
    };
}

