{ pkgs, ...}:
{ # If, for any reason, we need to turn off nixvim
        environment.systemPackages = with pkgs; [
    		neovim
        ];
}
