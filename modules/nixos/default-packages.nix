# List of packages that should be installed on everything. Mostly utilities stuff

{lib, config, pkgs, ...}:

{
    config = {
        programs.firefox.enable = true;
        services.flatpak.enable = true;

        environment.systemPackages = with pkgs; [
            filezilla
            librewolf # TODO : https://nixos.wiki/wiki/Librewolf#Configuration
            obs-studio
            nh
            tree
            prismlauncher
            python3
            htop
            expect
            jq
            unar
            nil
            mpv
            # dunst (Replaced by custom package, see qtile.nix)
            libnotify
	    nix-output-monitor
	    nvd
        ];
    };
}
