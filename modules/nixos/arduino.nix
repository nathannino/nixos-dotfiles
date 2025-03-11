

{lib, config, pkgs, ...}:

{
    config = {

		nixpkgs.overlays = [
			(self: super: {
				arduino-ide = super.arduino-ide.overrideAttrs(new: old: {
					nativeBuildInputs = old.nativeBuildInputs or [] ++ [ super.xorg.libxkbfile ];
				});
			})
		];

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
