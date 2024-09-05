
{lib, config, pkgs, ...}:

let cfg = config.keyboardmodule;
in
{
    options.keyboardmodule = {
	layout = lib.mkOption {
		type = types.string;
		default = "us"
	};
	options = lib.mkOption {
		type = types.string;
		default = ""
	};
    }
    config = {
	services.xserver = {
		xkb.layout = cfg.layout;
		xkb.options = cfg.options;
	};
    };
}
