# TODO : Switch to godot mono support

{lib, config, pkgs, ...}:

{
    config = {

   	nixpkgs.overlays = [
		(self: super: {
			slack = super.slack.overrideAttrs(new: old: {
				postPatch = let
					desktopfile = ''
						[Desktop Entry]
						Name=Slack
						StartupWMClass=Slack
Comment=Slack Desktop
						GenericName=Slack Client for Linux
						Exec=${pkgs.bashInteractive}/bin/sh -c "${pkgs.killall}/bin/killall slack ; ${pkgs.slack}/bin/slack -s %U"
						Icon=slack
						Type=Application
						StartupNotify=true
						Categories=GNOME;GTK;Network;InstantMessaging;
						MimeType=x-scheme-handler/slack;
					'';
				in old.postPatch + ''
					echo ${desktopfile} > $out/share/applications/slack.desktop
					chmod 777 $out/share/applications/slack.desktop
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

