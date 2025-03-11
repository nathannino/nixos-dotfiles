

{lib, config, pkgs, ...}:

{

   	nixpkgs.overlays = [
			(self: super: {
				arduino-ide = super.arduino-ide.overrideAttrs(new: old: { # Fix qtile wayland issue with slack
					propogatedBuildInputs = old.propogatedBuildInputs ++ [super.python3Packages.pyserial];
				});
			})
		];

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
