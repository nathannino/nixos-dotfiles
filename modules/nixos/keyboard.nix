
{lib, config, pkgs, ...}:

let cfg = config.keyboardmodule;
in
{
	options.keyboardmodule = {
		layout = lib.mkOption {
			type = lib.types.str;
			default = "us";
		};
		variant = lib.mkOption {
			type = lib.types.str;
			default = "";
		};
		options = lib.mkOption {
			type = lib.types.str;
			default = "";
		};
	};
	config = {
		services.xserver = {
			xkb.layout = cfg.layout;
			xkb.variant = cfg.variant;
			xkb.options = cfg.options;
		};

		environment.variables = {
			XKB_DEFAULT_LAYOUT = cfg.layout;
			XKB_DEFAULT_VARIANT = cfg.variant;
			XKB_DEFAULT_OPTIONS = cfg.options;
		};
	};
}
