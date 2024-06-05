# https://mynixos.com/options/xdg.userDirs
# To be fair, most of this is default values, since kde might have created them automatically?

{ config, pkgs, inputs, ... }:

{
    xdg.userDirs = {
        enable = true;
        # createDirectories = true; #Dunnu why it is causing backup issues
    };
}
