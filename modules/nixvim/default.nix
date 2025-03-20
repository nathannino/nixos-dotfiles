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
				action = "<cmd>NvimTreeToggle<CR>";
				key = "<C-tab>";
				mode = ["n"];
				options = {
					desc = "Toggle file tree.";
				};
			}
		];

		plugins = {
			lualine.enable = true;

			treesitter = {
				enable = true;
				gccPackage = null;
				nixGrammars = true;
				settings = {
					highlight.enable = true;
					indent.enable = true;
				};
			};

			treesitter-context = {
				enable = true;
				settings = { max_lines = 5; };
			};

			treesitter-refactor = {
				enable = true;
				highlightCurrentScope.enable = true;
				navigation = {
					enable = true;
				};
			};

			rainbow-delimiters.enable = true;

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
				openOnSetup = true;
				openOnSetupFile = true;
				autoReloadOnWrite = true;
			};

			web-devicons.enable = true;

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

			#TODO : Seperate nvim-platformio dependencies into other file (https://github.com/anurag3301/nvim-platformio.lua)
			#telescope.enable = true;
		};

		# TODO : nvim-platformio support. I really did try... =(
		#extraPlugins = [
		#	(pkgs.vimUtils.buildVimPlugin {
		#		name = "nvim-platformio";
		#
		#		src = pkgs.fetchFromGitHub {
		#			owner = "anurag3301";
		#			repo = "nvim-platformio.lua";
		#			rev = "ccca890e2e1ee7822a64ae501866a027d975ab71";
		#			hash = "sha256:15hwsk8y0na3zjj2kbx929vz50vkdkwvjs7vhbk5lq13pp0vajvc";
		#		};
		#	})
		#];

		#extraConfigLua = ''
		#	require('platformio').setup({
		#		lsp = "clangd" --default: ccls, other option: clangd
		#             -- If you pick clangd, it also creates compile_commands.json
		#	})
		#'';

		performance = {
			byteCompileLua.enable = true;
			# combinePlugins.enable = true; # Doesn't work lol
		};
	};
}
