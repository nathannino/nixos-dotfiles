# Steam and steam related programs.
# Not called gaming because Minecraft?
# Also testing not having an enable option
# Wikipage : https://nixos.wiki/wiki/Steam

{lib, config, pkgs, ...}:

{
    config = {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            gamescopeSession.enable = true; # We will try without for now, but might need to for wayland
        };

        environment.systemPackages = with pkgs; [
            protonup #Imperative (not declarative), but since steam updates automatically anyways... is fine
	    itch # not steam, but like....
        ];
    };
}
