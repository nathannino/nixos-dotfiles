# TODO : Switch to godot mono support

{lib, config, pkgs, ...}:

{
	config = {

   	nixpkgs.overlays = [
			(self: super: {
				slack = super.slack.overrideAttrs(new: old: { # Fix qtile wayland issue with slack
					postInstall = ''
						substituteInPlace $out/share/applications/slack.desktop \
        			--replace "$out/bin/slack" "${pkgs.bashInteractive}/bin/sh -c \"${pkgs.killall}/bin/killall slack ; $out/bin/slack -s %U\""
					'';
				});
			})
		];

    environment.systemPackages = with pkgs; [
      slack
	  	teams-for-linux # Insert swear word here
  	];
  };
}

