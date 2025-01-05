{ pkgs, ...}:
{
	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

		clipboard = {
			register = "unnamedplus";
			providers.xsel.enable = true;
			providers.wl-copy.enable = true;
		};

		colorschemes = {
			onedark = {
				enable = true;
			};
		};
	};
}
