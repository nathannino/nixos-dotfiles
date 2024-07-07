# https://github.com/nix-community/home-manager/blob/master/modules/services/mpd.nix
{ config, pkgs, inputs, ... }:

let
  cfg = config.mpduser;
in
{
  options.mpduser = {
  	directory = lib.mkOption
  };
  config = {
    services.mpd = {
        enable = true;
        extraConfig = ''
            follow_outside_symlinks "yes"
            follow_inside_symlinks "yes"
            audio_output {
	type		"pipewire"
	name		"PipeWire Sound Server"
}
        '';
	musicDirectory = cfg.directory;
    };
  };
}
