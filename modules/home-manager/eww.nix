# TODO : eww will break once a nh os switch happens, if config hash changes. https://github.com/elkowar/eww/discussions/620 has a solution, but this breaks the ability to revert to a previous gen, so we should probably not do it until we get git on this repo with an autotag feature
# Otherwise, we can simply restart the session, as that will kill the old eww. Technically, we only need to do this if the config changes it's hash, and it shouldn't do this if we don't touch the eww config, iirc

{ config, pkgs, ...} :

{
	home.file = {
		".config/eww/" = {
			source = ./files/eww; # To use when not modifying eww, to allow reverting without having to handle git
			# source = config.lib.file.mkOutOfStoreSymlink ./files/eww; # To use when modifying eww.
			recursive = true;
		};
	};
}
