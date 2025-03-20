{ pkgs, ...}:
{
	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

		opts = {
			number = true;

			tabstop = 2;
			shiftwidth = 2;
		};

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

		keymaps = [
			{
				action = "<cmd>NvimTreeOpen<CR>";
				key = "<C-tab>";
				mode = ["n"];
				options = {
					desc = "Toggle file tree.";
				};
			}
		];

		plugins = {
			lualine.enable = true;

			treesitter.enable = true;

			clangd-extensions.enable = true;

			toggleterm = {
				enable = true;
				settings = {
					open_mapping = "[[<F2>]]";
				};
			};

			nvim-tree = {
				enable = true;
				hijackCursor = true;
			};

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
					lua_ls.enable = true;
					pyright.enable = true;
					nil_ls.enable = true;
					clangd.enable = true;
				};
			};

			cmp = {
				enable = true;
				autoEnableSources = true;
				settings = {
					sources = [
						{name = "nvim_lsp";}
						{name = "path";}
						{name = "buffer";}
					];
					mapping = {
						"<C-Space>" = "cmp.mapping.complete()";
						"<C-d>" = "cmp.mapping.scroll_docs(-4)";
						"<C-e>" = "cmp.mapping.close()";
						"<C-f>" = "cmp.mapping.scroll_docs(4)";
						"<CR>" = "cmp.mapping.confirm({ select = true })";
						"<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
						"<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
					};
				};
			};
		};

		performance = {
			byteCompileLua.enable = true;
			# combinePlugins.enable = true; # Doesn't work lol
		};
	};
}
