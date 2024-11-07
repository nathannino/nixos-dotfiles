# List of packages that should be installed on everything. Mostly utilities stuff

{lib, config, pkgs, ...}:

{
    config = {
  	# List packages installed in system profile. To search, run:
  	# $ nix search wget
        environment.systemPackages = with pkgs; [
		virtiofsd
        ];
    };
}
