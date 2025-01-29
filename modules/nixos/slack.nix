# TODO : Switch to godot mono support

{lib, config, pkgs, ...}:

{
    config = {

   	nixpkgs.overlays = [
		(self: super: {
			slack = super.slack.overrideAttrs(new: old: { # Fix qtile wayland issue with slack
				#postInstall = let
				#	desktopfile = ''
				#		[Desktop Entry]
				#		Name=Slack
				#		StartupWMClass=Slack
				#		Comment=Slack Desktop
				#		GenericName=Slack Client for Linux
				#		Exec=${pkgs.bashInteractive}/bin/sh -c "${pkgs.killall}/bin/killall slack ; $out/bin/slack -s %U"
				#		Icon=slack
				#		Type=Application
				#		StartupNotify=true
				#		Categories=GNOME;GTK;Network;InstantMessaging;
				#		MimeType=x-scheme-handler/slack;
				#	'';
				#in (old.postInstall or "") + ''
				#	echo "${desktopfile}" > $out/share/applications/slack.desktop
				#	chmod 777 $out/share/applications/slack.desktop
				#'';

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

