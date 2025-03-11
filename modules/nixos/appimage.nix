# Yay osu
{lib, config, pkgs, ...}:

{
    config = {
        programs.appimage = {
            enable = true;
            binfmt = true;
            package = pkgs.appimage-run.override {
                extraPkgs = pkgs: [ 
								pkgs.icu
								(pkgs.python3.withPackages (python-pkgs: [
									python-pkgs.pyserial
								]))
								];
            };
        };
    };
}

