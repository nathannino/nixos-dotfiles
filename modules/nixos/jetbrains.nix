{lib, config, pkgs, ...}:

let
  cfg = config.jetbrainide;
in
{
  options.jetbrainide = {
    ultimate = lib.mkEnableOption "enable paid jetbrains";
  };

  config = lib.mkMerge 
  	[
		(lib.mkIf cfg.ultimate {
  			environment.systemPackages = with pkgs; [
				jetbrains.idea-ultimate
				jetbrains.rider
				jetbrains.clion
				jetbrains.webstorm
				jetbrains.pycharm-professional
			];
    		})
		(lib.mkIf (!cfg.ultimate) {
  			environment.systemPackages = with pkgs; [
				jetbrains.idea-community-bin
				jetbrains.pycharm-community-bin
			];
		})
	];
}
