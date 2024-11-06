# qt styles ftw yay
{ config, pkgs, inputs, ... }:

{
	qt = {
		enable = true;
		platformTheme.name = "kde";
		style.name = "breeze";
	};

	gtk = {
		enable = true;
		theme = {
			name = "Breeze-Dark";
			package = pkgs.kdePackages.breeze-gtk;
		};
		iconTheme = {
			package = pkgs.kdePackages.breeze-icons;
			name = "Breeze-Dark";
		};
	};
}
