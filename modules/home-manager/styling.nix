# qt styles ftw yay
{ config, pkgs, inputs, ... }:

{
	qt = {
		enable = true;
		platformTheme = "kde";
		style.name = "Breeze-Dark";
	};

	gtk = {
		enable = true;
		theme = {
			name = "Breeze-Dark";
			package = pkgs.kdePackages.breeze-gtk;
		};
	};
}
