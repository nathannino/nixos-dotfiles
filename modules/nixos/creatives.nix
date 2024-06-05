# Seperated because I am not sure I want this to be default, but will be default by default

{lib, config, pkgs, ...}:

{
    config = {
        programs.firefox.enable = true;
        services.flatpak.enable = true;

        environment.systemPackages = with pkgs; [
            krita
            inkscape
            libsForQt5.kdenlive # wtf is that in libsForQt5???
        ];
    };
}

