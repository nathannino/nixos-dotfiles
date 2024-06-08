
{lib, config, pkgs, ...}:

{
    config = {
        programs.firefox.enable = true;
        services.flatpak.enable = true;

        environment.systemPackages = with pkgs; [
		(pkgs.writeShellApplication {
			name = "nnix";
			text = builtins.readFile ./../../scripts/nnix.sh;
		})
        ];
    };
}
