{ pkgs, ...}:
{ # If, for any reason, we need to turn off nixvim
	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;
}
