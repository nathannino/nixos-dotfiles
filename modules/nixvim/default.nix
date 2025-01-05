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
					lua-ls.enable = true;
					pyright.enable = true;
					nil_ls.enable = true;
				};
			};

			nvim-cmp = {
				enable = true;
				autoEnableSources = true;
				sources = [
					{name = "nvim_lsp";}
					{name = "path";}
					{name = "buffer";}
				];
				mapping = {
					"<CR>" = "cmp.mapping.confirm({ select = true })";
					"<Tab>" = {
						action = ''
							function(fallback)
								if cmp.visible() then
									cmp.select_next_item()
								else
									fallback()
								end
							end
						'';
						mode = [ "i" "s" ];
					};
				};
			};
		};

	};
}
