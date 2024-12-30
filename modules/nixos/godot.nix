# TODO : Remove Insecure Packages exception once possible

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

