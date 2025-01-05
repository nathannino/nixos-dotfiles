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
			providers.wl-copy.enable = true;d.
		};

		colorschemes = {
			onedark = {
				enable = true;
			};
		};
	};
}
