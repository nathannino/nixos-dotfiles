# https://nixos.wiki/wiki/Git
{ config, pkgs, inputs, ... }:

{
	programs.git = {
		enable = true;
		userName = "Nathan Marien";
		userEmail = "yohanpro.jimdo.com@gmail.com";
		extraConfig = {
			init.defaultBranch = "main";
		};
	};
}
