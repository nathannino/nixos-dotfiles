# Yay osu
{lib, config, pkgs, ...}:

{
    config = {
        programs.appimage = {
            enable = true;
            binfmt = true;
            package = pkgs.appimage-run.override {
                extraPkgs = pkgs: [ pkgs.icu];
            };
        };
    };
}

