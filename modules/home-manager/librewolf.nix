# https://nixos.wiki/wiki/Librewolf
{ config, pkgs, inputs, ... }:

{
    programs.librewolf = {
        enable = true;
        settings = {
            "privacy.clearOnShutdown.cookies" = false; # TODO : get a security key that can do passwordless logins, so that I can reenable this
            "middlemouse.paste" = false;
            "general.autoScroll" = true;
            "security.OCSP.require" = false; # TODO : Check if this is really needed. It might not be too bad to just toggle it when necessary...
            "network.cookie.lifetimePolicy" = 0; #TODO : Very not sure if I actually want thsi...
        };
    };
}
