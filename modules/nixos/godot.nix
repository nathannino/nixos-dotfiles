# TODO : Remove Insecure Packages exception once possible

{lib, config, pkgs, pkgs-stable, ...}:

{
    config = {

        environment.systemPackages = with pkgs; [
            pkgs-stable.godot_4
        ];
    };
}

