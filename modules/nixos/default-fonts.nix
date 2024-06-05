# Here to seperate fonts from utilities, but otherwise serving the same purpose as default-packages.nix

{lib, config, pkgs, ...}:

{
    config = {
        environment.systemPackages = with pkgs; [
		nerdfonts
        ];
    };
}
