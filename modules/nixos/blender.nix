# Seperated in case I don't want blender on other laptop tbh TODO : Might want to merge back into defaults
{lib, config, pkgs, ...}:

{
    config = {

        environment.systemPackages = with pkgs; [
            blender
        ];
    };
}

