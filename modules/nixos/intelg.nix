# based on nvidia.nix, modified using nixos.wiki (https://nixos.wiki/wiki/Intel_Graphics)
{lib, config, pkgs, ...}:

{
    hardware.opengl = {
      enable = true;
      # driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        vlp-gpu-rt
      ];
    };

    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
}
