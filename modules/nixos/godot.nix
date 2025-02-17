# TODO : Remove Insecure Packages exception once possible

{lib, config, pkgs, ...}:

{
    config = {

        environment.systemPackages = with pkgs; [
            godot_4
        ];
    };
}

