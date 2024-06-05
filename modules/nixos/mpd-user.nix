# TODO : It's a user-service version of mpd, so it's configured in home-manager
{config, lib, pkgs, modulesPath, ... }:

{
    config = {
        environment.systemPackages = with pkgs; [
            mpc-cli
            ymuse
            #mpd # The fact this only works with mpd commented is pretty dumb imo, but ok, system package messes things up I guess.
        ];
    };
}
