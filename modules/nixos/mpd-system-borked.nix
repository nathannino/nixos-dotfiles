# TODO : BROKEN OMG wtf
# SOund is broken because can't connect to stream or something
# Symlink is broken because can't see it or something...
# We should be able to move it to home-manager tho? maybe? https://github.com/nix-community/home-manager/blob/master/modules/services/mpd.nix

{config, lib, pkgs, modulesPath, ... }:

let
  cfg = config.mpdmodule;
in
{
  options.mpdmodule = {
    user = lib.mkOption {
        default = "nathan_nino";
    };
  };
    config = {
        services.mpd = {
            enable = true;
            user = "nathan_nino";
            extraConfig = ''
            follow_outside_symlinks "yes"
            follow_inside_symlinks "yes"
            audio_output {
	type		"pipewire"
	name		"PipeWire Sound Server"
}
            '';
        };
        environment.systemPackages = with pkgs; [
            mpc-cli
            ymuse
        ];
        systemd.services.mpd.environment = { # https://nixos.wiki/wiki/MPD#PipeWire
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.nathan_nino.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
};
        systemd.services.mpd_create_symlink_to_home = {
            description = "Add symlink to user directory";
            script = ''
                rm /var/lib/mpd/music/home
                ln -s "/home/${cfg.user}/Music" "/var/lib/mpd/music/home"
            '';
            wantedBy = ["mpd.service"];
        };
    };
}
