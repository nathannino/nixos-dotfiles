

{lib, config, pkgs, ...}:

{
    config = {
  	# List packages installed in system profile. To search, run:
  	# $ nix search wget
        environment.systemPackages = with pkgs; [
					arduino-ide
					arduino-core
					arduino
					arduino-cli
        ];
    };
}
