{ pkgs, ...}:
{
	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

		clipboard.register = "unnamedplus";
		clipboard.providers.xsel.enable = true;
	};
}
