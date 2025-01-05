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

		plugins = {
			lualine.enable = true;

			lsp = {
				enable = true;
				
				servers = {
					ts_ls.enable = true;
					rust_analyzer = {
						enable = true;
						installCargo = true;
						installRustc = true;
						installRustfmt = true;
					};
					pyright.enable = true;
					nil_ls.enable = true;
				};
			};
		};
	};
}
