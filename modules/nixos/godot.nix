# TODO : Switch to godot mono support

{lib, config, pkgs, ...}:

{
    config = {

        environment.systemPackages = with pkgs; [
            godot_4-mono
        ];

	nixpkgs.config.permittedInsecurePackages = [
		"dotnet-sdk-6.0.428"
	];
    };
}

