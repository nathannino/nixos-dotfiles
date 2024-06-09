# nvidia bs file because ndidia graphics card
# btw, since this is my first nix module, tutorial used to make this, kept for future reference : https://www.youtube.com/watch?v=a67Sv4Mbxmc
{lib, config, pkgs, ...}:

let
  cfg = config.jetbrainide;
in
{
  options.jetbrainide = {
    ultimate = lib.mkEnableOption "enable nvidia graphics driver";
  };

  config = lib.mkMerge 
  	[
		(lib.mkIf cfg.ultimate {
  			environment.systemPackages = with pkgs; [
				jetbrains.idea-ultimate
				jetbrains.rider
				jetbrains.clion
				jetbrains.webstorm
			];
    		})
		(lib.mkIf !cfg.ultimate {
  			environment.systemPackages = with pkgs; [
				jetbrains.idea-community-bin
			];
		})
	];
  };
}
