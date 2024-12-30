# Here to seperate fonts from utilities, but otherwise serving the same purpose as default-packages.nix

{lib, config, pkgs, ...}:

{
    config = {
        environment.systemPackages = with pkgs; [
		nerd-fonts.ubuntu-mono
		nerd-fonts.symbols-only
		nerd-fonts.caskaydia-cove
        ];
    };
}
