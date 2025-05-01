# List of packages that should be installed on everything. Mostly utilities stuff

{lib, config, pkgs, ...}:

{
    config = {
        programs.firefox.enable = true;
        services.flatpak.enable = true;

  	# List packages installed in system profile. To search, run:
  	# $ nix search wget
        environment.systemPackages = with pkgs; [
    		# vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    		# neovim # check the nixvim module
    		wget
    		vesktop
    		git
    		alacritty
    		bat
		killall
			filezilla
			librewolf # TODO : https://nixos.wiki/wiki/Librewolf#Configuration
			obs-studio
			nh
			tree
			prismlauncher
			python3
			htop
			expect
			jq
			unar
			nil
			mpv
			# dunst (Replaced by custom package, see qtile.nix)
			libnotify
	    	nix-output-monitor
	    	nvd
	    	qpwgraph
	    	rssguard
		waycheck
		devenv
		calc
		flameshot
		libreoffice
		maven
		(with dotnetCorePackages; combinePackages [
			sdk_8_0
		])
		adwaita-icon-theme
			segger-jlink # very temp aaa
        ];
    };
}
