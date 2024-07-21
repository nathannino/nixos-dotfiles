# based on nvidia.nix, modified using nixos.wiki (https://nixos.wiki/wiki/Intel_Graphics)
{lib, config, pkgs, ...}:

{
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        vpl-gpu-rt
      ];
    };

    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
}
